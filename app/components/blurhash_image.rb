# frozen_string_literal: true

module Components
  class BlurhashImage < Components::Base
    def initialize(source:, **options)
      @source = source
      @options = options
    end

    def view_template
      blob = extract_blob(@source)

      blurhash = blob&.metadata&.fetch('blurhash', nil)

      size = "#{blob&.metadata&.fetch('width', nil)}x#{blob&.metadata&.fetch('height', nil)}"

      image_options = @options.dup
      image_options[:loading] = 'lazy'
      image_options[:size] = size

      # Extract wrapper and canvas classes
      wrapper_class = image_options.delete(:wrapper_class)
      canvas_class = image_options.delete(:canvas_class)

      if blurhash
        div(
          class: wrapper_class,
          data: { blurhash: },
          style: 'position: relative'
        ) do
          image_tag(@source, **image_options)
          canvas(
            style: 'position: absolute; inset: 0; transition-property: opacity; transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1); transition-duration: 150ms;',
            class: canvas_class
          )
        end
      else
        img(src: @source, **image_options)
      end
    end

    private

    def extract_blob(source)
      case source
      when String
        begin
          path_parameters = Rails.application.routes.recognize_path(source)
          ActiveStorage::Blob.find_signed!(path_parameters[:signed_blob_id] || path_parameters[:signed_id])
        rescue ActionController::RoutingError
          nil
        end
      when ActiveStorage::Blob
        source
      when ActiveStorage::Attached::One
        source.blob
      when ActiveStorage::VariantWithRecord
        source.blob
      else
        nil
      end
    end
  end
end
