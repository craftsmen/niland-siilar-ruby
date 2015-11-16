module Siilar
  class Client
    module Tracks

      # Gets a track.
      #
      # @see http://api.siilar.com/1.0/doc/tracks#get-a-track
      def track(track)
        response = client.get("1.0/tracks/#{track}")

        Struct::Track.new(response)
      end

      # Gets an external track.
      #
      # @see https://api.niland.io/doc/tracks#get-an-external-track
      def external_track(track)
        response = client.get("1.0/external-tracks/#{track}")

        Struct::ExternalTrack.new(response)
      end

      # Gets a track from its external id.
      #
      # @see https://api.niland.io/doc/tracks#get-tracks-from-external
      def from_external(track)
        response = client.get("1.0/from-external/#{track}")

        Struct::Track.new(response)
      end

      # Creates a track.
      #
      # @see http://api.siilar.com/1.0/doc/tracks#create-a-track
      def create(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:title, :external_id])
        response = client.post('1.0/tracks', attributes)

        Struct::Track.new(response)
      end

      # Updates a track.
      #
      # @see http://api.siilar.com/1.0/doc/tracks#edit-a-track
      def update(track, attributes = {})
        response = client.patch("1.0/tracks/#{track}", attributes)

        Struct::Track.new(response)
      end

      # Deletes a track.
      #
      # @see http://api.siilar.com/1.0/doc/tracks#delete-a-track
      def delete(track)
        client.delete("1.0/tracks/#{track}")
      end
    end
  end
end
