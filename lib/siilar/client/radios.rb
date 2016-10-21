module Siilar
  class Client
    module Radios

      # Get a list of your radios.
      #
      # @see http://api.niland.io/2.0/doc/radios#list-radios
      def list
        response = client.get('2.0/radios')
        response['data'].map { |radio| Struct::Radio.new(radio) }
      end

      # Get a radio.
      #
      # @see http://api.niland.io/2.0/doc/radios#get-a-radio
      def get(radio)
        response = client.get("2.0/radios/#{radio}")
        Struct::Radio.new(response)
      end

      # Create a radio.
      #
      # @see http://api.niland.io/2.0/doc/radios#create-a-radio
      def create(attributes = {})
        response = client.post('2.0/radios', attributes)
        Struct::Radio.new(response)
      end

      # Edit a radio.
      #
      # @see http://api.niland.io/2.0/doc/radios#edit-a-radio
      def edit(radio, attributes = {})
        response = client.patch("2.0/radios/#{radio}", attributes)
        Struct::Radio.new(response)
      end

      # Delete a radio.
      #
      # @see http://api.niland.io/2.0/doc/radios#delete-a-radio
      def delete(radio, attributes = {})
        response = client.delete("2.0/radios/#{radio}")
      end

      # Get next radio tracks
      #
      # @see http://api.niland.io/2.0/doc/radios#get-next-radio-tracks
      def get_next(radio)
        response = client.get("2.0/radios/#{radio}/next")
        response.map { |track| Struct::Track.new(track) }
      end

      # Notify a skip.
      #
      # @see http://api.niland.io/2.0/doc/radios#notify-a-skip
      def notify_skip(radio, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("2.0/radios/#{radio}/skips", attributes)
        Struct::Radio.new(response)
      end

      # Notify a like.
      #
      # @see http://api.niland.io/2.0/doc/radios#notify-a-like
      def notify_like(radio, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("2.0/radios/#{radio}/likes", attributes)
        Struct::Radio.new(response)
      end

      # Notify a dislike.
      #
      # @see http://api.niland.io/2.0/doc/radios#notify-a-dislike
      def notify_dislike(radio, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("2.0/radios/#{radio}/dislikes", attributes)
        Struct::Radio.new(response)
      end

      # Notify a ban.
      #
      # @see http://api.niland.io/2.0/doc/radios#notify-a-ban
      def notify_ban(radio, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("2.0/radios/#{radio}/bans", attributes)
        Struct::Radio.new(response)
      end

      # Notify a favorite.
      #
      # @see http://api.niland.io/2.0/doc/radios#notify-a-favorite
      def notify_favorite(radio, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("2.0/radios/#{radio}/favorites", attributes)
        Struct::Radio.new(response)
      end

      # Notify a not played track.
      #
      # @see http://api.niland.io/2.0/doc/radios#notify-a-not-played-track
      def notify_not_played(radio, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("2.0/radios/#{radio}/notplayed", attributes)
        Struct::Radio.new(response)
      end
    end
  end
end
