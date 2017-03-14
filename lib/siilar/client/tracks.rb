module Siilar
  class Client
    module Tracks

      # List tracks.
      #
      # @see http://api.niland.io/2.0/doc/tracks#list-tracks
      def tracks(query = {})
        options = { query: query }
        response = client.get("2.0/tracks", options)

        response['data'].map { |track| Struct::Track.new(track) }
      end

      # Gets a track.
      #
      # @see http://api.niland.io/2.0/doc/tracks#get-a-track
      def track(track)
        response = client.get("2.0/tracks/#{track}")

        Struct::Track.new(response)
      end

      # Gets a track from its internal reference.
      #
      # @see https://api.niland.io/doc/tracks#get-a-track-from-your-internal-reference
      def from_reference(reference)
        response = client.get("2.0/tracks/reference/#{reference}")

        Struct::Track.new(response)
      end

      # Creates a track.
      #
      # @see http://api.niland.io/2.0/doc/tracks#create-a-track
      def create(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:title, :reference])
        response = client.post('2.0/tracks', attributes)

        Struct::Track.new(response)
      end

      # Upload a temporary track.
      #
      # @see https://api.niland.io/2.0/doc/tracks#upload-a-temporary-track
      # def upload_temporary(attributes = {})
      #   options = {
      #     headers: {
      #       'Content-Type' => 'multipart/form-data'
      #     }
      #   }
      #   Extra.validate_mandatory_attributes(attributes, [:file])
      #   response = client.execute(:post, '2.0/tracks/temporaries', attributes, options)

      #   Struct::TemporaryTrack.new(response)
      # end

      # Updates a track.
      #
      # @see http://api.niland.io/2.0/doc/tracks#edit-a-track
      def update(track, attributes = {})
        response = client.patch("2.0/tracks/#{track}", attributes)

        Struct::Track.new(response)
      end

      # Updates a track audio file
      #
      # @see https://api.niland.io/2.0/doc/tracks#upload-a-temporary-track
      # def edit_audio_file(track, attributes = {})
      #   options = {
      #     headers: {
      #       'Content-Type' => 'multipart/form-data'
      #     }
      #   }
      #   response = client.execute(:post, "2.0/tracks/#{track}/audio", attributes, options)

      #   Struct::Track.new(response)
      # end

      # Deletes a track.
      #
      # @see http://api.niland.io/2.0/doc/tracks#delete-a-track
      def delete(track)
        client.delete("2.0/tracks/#{track}")
      end


      # Gets a track's tags.
      #
      # @see https://api.niland.io/2.0/doc/tracks#get-track-tags
      def tags(track)
        response = client.get("2.0/tracks/#{track}/tags")

        response.map { |tag| Struct::Tag.new(tag) }
      end


      # Gets a track's tags from its internal reference.
      #
      # @see https://api.niland.io/2.0/doc/tracks#get-track-tags
      def tags_from_reference(reference)
        response = client.get("2.0/tracks/reference/#{reference}/tags")

        response.map { |tag| Struct::Tag.new(tag) }
      end
    end
  end
end
