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

module ReadingCustomization
  # Canonical v1 preference document for reading customization (T-PS-01).
  #
  # Source of truth for keys, defaults, enums, and ranges used by later
  # persistence (T-PS-02) and client (T-PS-04) work. Does not persist data.
  #
  # @see doc/api/reading_customization_preferences.md
  # @see agents/tasks/feature-preference-storage/implementation-research.md
  module PreferenceSchema
    VERSION = 1

    THEME_MODES = %w[system light dark].freeze
    PRESET_IDS = %w[none dyslexia_friendly low_strain high_clarity custom].freeze
    FONT_FAMILIES = %w[default classic dyslexic].freeze
    EMPHASIS_LEVELS = %w[off standard strong].freeze

    TEXT_SCALE_PERCENT_MIN = 100
    TEXT_SCALE_PERCENT_MAX = 150

    LINE_HEIGHT_MULTIPLIER_MIN = 1.0
    LINE_HEIGHT_MULTIPLIER_MAX = 2.0
    LETTER_SPACING_MULTIPLIER_MIN = 1.0
    LETTER_SPACING_MULTIPLIER_MAX = 1.5
    PARAGRAPH_SPACING_MULTIPLIER_MIN = 1.0
    PARAGRAPH_SPACING_MULTIPLIER_MAX = 2.0

    DEFAULTS = {
      "reading_customization_version" => VERSION,
      "theme_mode" => "system",
      "active_preset_id" => "none",
      "typography" => {
        "font_family" => "default",
        "text_scale_percent" => 100,
        "line_height_multiplier" => 1.0,
        "letter_spacing_multiplier" => 1.0,
        "paragraph_spacing_multiplier" => 1.0
      }.freeze,
      "emphasis_level" => "off"
    }.freeze

    module_function

    # @return [Hash] deep copy of DEFAULTS suitable for mutation by callers
    def defaults
      deep_dup_hash(DEFAULTS)
    end

    # Merge a partial preference hash onto defaults without wiping unrelated keys.
    # Invalid keys are ignored; invalid values raise ArgumentError.
    #
    # @param partial [Hash, nil]
    # @return [Hash] validated complete preference document
    def merge_with_defaults(partial)
      result = defaults
      return result if partial.nil? || partial.empty?

      normalize = stringify_keys(partial)
      apply_top_level!(result, normalize)
      apply_typography!(result, normalize["typography"]) if normalize.key?("typography")
      validate!(result)
      result
    end

    # @param document [Hash]
    # @return [true]
    # @raise [ArgumentError] when the document violates v1 schema
    def validate!(document)
      doc = stringify_keys(document)
      version = doc["reading_customization_version"]
      unless version == VERSION
        raise ArgumentError, "reading_customization_version must be #{VERSION}"
      end

      unless THEME_MODES.include?(doc["theme_mode"])
        raise ArgumentError, "theme_mode must be one of #{THEME_MODES.join(", ")}"
      end

      unless PRESET_IDS.include?(doc["active_preset_id"])
        raise ArgumentError, "active_preset_id must be one of #{PRESET_IDS.join(", ")}"
      end

      unless EMPHASIS_LEVELS.include?(doc["emphasis_level"])
        raise ArgumentError, "emphasis_level must be one of #{EMPHASIS_LEVELS.join(", ")}"
      end

      typography = doc["typography"]
      raise ArgumentError, "typography must be a Hash" unless typography.is_a?(Hash)

      typography = stringify_keys(typography)
      unless FONT_FAMILIES.include?(typography["font_family"])
        raise ArgumentError, "font_family must be one of #{FONT_FAMILIES.join(", ")}"
      end

      assert_integer_in_range!(
        typography["text_scale_percent"],
        "text_scale_percent",
        TEXT_SCALE_PERCENT_MIN,
        TEXT_SCALE_PERCENT_MAX
      )
      assert_float_in_range!(
        typography["line_height_multiplier"],
        "line_height_multiplier",
        LINE_HEIGHT_MULTIPLIER_MIN,
        LINE_HEIGHT_MULTIPLIER_MAX
      )
      assert_float_in_range!(
        typography["letter_spacing_multiplier"],
        "letter_spacing_multiplier",
        LETTER_SPACING_MULTIPLIER_MIN,
        LETTER_SPACING_MULTIPLIER_MAX
      )
      assert_float_in_range!(
        typography["paragraph_spacing_multiplier"],
        "paragraph_spacing_multiplier",
        PARAGRAPH_SPACING_MULTIPLIER_MIN,
        PARAGRAPH_SPACING_MULTIPLIER_MAX
      )

      true
    end

    def apply_top_level!(result, normalize)
      %w[theme_mode active_preset_id emphasis_level].each do |key|
        result[key] = normalize[key] if normalize.key?(key)
      end
      if normalize.key?("reading_customization_version")
        result["reading_customization_version"] = normalize["reading_customization_version"]
      end
    end
    private_class_method :apply_top_level!

    def apply_typography!(result, typography_partial)
      raise ArgumentError, "typography must be a Hash" unless typography_partial.is_a?(Hash)

      partial = stringify_keys(typography_partial)
      typography = result["typography"]
      %w[
        font_family
        text_scale_percent
        line_height_multiplier
        letter_spacing_multiplier
        paragraph_spacing_multiplier
      ].each do |key|
        typography[key] = partial[key] if partial.key?(key)
      end
    end
    private_class_method :apply_typography!

    def assert_integer_in_range!(value, name, min, max)
      unless value.is_a?(Integer) && value >= min && value <= max
        raise ArgumentError, "#{name} must be an Integer between #{min} and #{max}"
      end
    end
    private_class_method :assert_integer_in_range!

    def assert_float_in_range!(value, name, min, max)
      unless value.is_a?(Numeric) && value.to_f >= min && value.to_f <= max
        raise ArgumentError, "#{name} must be a number between #{min} and #{max}"
      end
    end
    private_class_method :assert_float_in_range!

    def stringify_keys(hash)
      hash.each_with_object({}) do |(key, value), memo|
        memo[key.to_s] = value.is_a?(Hash) ? stringify_keys(value) : value
      end
    end
    private_class_method :stringify_keys

    def deep_dup_hash(hash)
      hash.transform_values { |value| value.is_a?(Hash) ? deep_dup_hash(value) : value }
    end
    private_class_method :deep_dup_hash
  end
end
