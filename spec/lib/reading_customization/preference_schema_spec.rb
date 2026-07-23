# frozen_string_literal: true

#
# Copyright (C) 2026 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

describe ReadingCustomization::PreferenceSchema do
  describe "VERSION" do
    it "is 1 for schema v1" do
      expect(described_class::VERSION).to eq(1)
    end
  end

  describe ".defaults" do
    it "includes a mandatory reading_customization_version of 1" do
      expect(described_class.defaults["reading_customization_version"]).to eq(1)
    end

    it "returns a deep copy that callers can mutate safely" do
      first = described_class.defaults
      second = described_class.defaults
      first["theme_mode"] = "dark"
      first["typography"]["text_scale_percent"] = 150
      expect(second["theme_mode"]).to eq("system")
      expect(second["typography"]["text_scale_percent"]).to eq(100)
    end

    it "matches the published v1 default document shape" do
      expect(described_class.defaults).to eq(
        "reading_customization_version" => 1,
        "theme_mode" => "system",
        "active_preset_id" => "none",
        "typography" => {
          "font_family" => "default",
          "text_scale_percent" => 100,
          "line_height_multiplier" => 1.0,
          "letter_spacing_multiplier" => 1.0,
          "paragraph_spacing_multiplier" => 1.0
        },
        "emphasis_level" => "off"
      )
    end
  end

  describe ".validate!" do
    it "accepts the default document" do
      expect(described_class.validate!(described_class.defaults)).to be true
    end

    it "rejects an unsupported theme_mode" do
      doc = described_class.defaults.merge("theme_mode" => "sepia")
      expect { described_class.validate!(doc) }.to raise_error(ArgumentError, /theme_mode/)
    end

    it "rejects text_scale_percent outside 100..150" do
      doc = described_class.defaults
      doc["typography"]["text_scale_percent"] = 200
      expect { described_class.validate!(doc) }.to raise_error(ArgumentError, /text_scale_percent/)
    end

    it "rejects a wrong schema version" do
      doc = described_class.defaults.merge("reading_customization_version" => 2)
      expect { described_class.validate!(doc) }.to raise_error(ArgumentError, /reading_customization_version/)
    end
  end

  describe ".merge_with_defaults" do
    it "applies a partial update without wiping unrelated keys" do
      merged = described_class.merge_with_defaults(
        "theme_mode" => "dark",
        "typography" => { "text_scale_percent" => 125 }
      )
      expect(merged["theme_mode"]).to eq("dark")
      expect(merged["active_preset_id"]).to eq("none")
      expect(merged["typography"]["text_scale_percent"]).to eq(125)
      expect(merged["typography"]["font_family"]).to eq("default")
      expect(merged["reading_customization_version"]).to eq(1)
    end

    it "raises when a partial update contains an invalid enum" do
      expect do
        described_class.merge_with_defaults("emphasis_level" => "extra")
      end.to raise_error(ArgumentError, /emphasis_level/)
    end
  end

  describe "ReadingCustomization::PREFERENCES_KEY" do
    it "names the User#preferences storage key" do
      expect(ReadingCustomization::PREFERENCES_KEY).to eq(:reading_customization)
    end
  end
end
