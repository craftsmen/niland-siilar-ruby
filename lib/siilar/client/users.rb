module Siilar
  class Client
    module Users

      # Get a list of your users.
      #
      # @see http://api.niland.io/1.0/doc/users#list-users
      def list(query = {})
        response = client.get('1.0/users')
        response.map { |user| Struct::User.new(user) }
      end

      # Get a user.
      #
      # @see http://api.niland.io/1.0/doc/users#get-a-user
      def get(user)
        response = client.get("1.0/users/#{user}")
        Struct::User.new(response)
      end

      # Create a user.
      #
      # @see http://api.niland.io/1.0/doc/users#create-a-user
      def create(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:external_id])
        response = client.post('1.0/users', attributes)
        Struct::User.new(response)
      end

      # Update a user.
      #
      # @see http://api.niland.io/1.0/doc/users#update-a-user
      def update(user, attributes = {})
        response = client.patch("1.0/users/#{user}", attributes)
        Struct::User.new(response)
      end

      # Delete a user.
      #
      # @see http://api.niland.io/1.0/doc/users#delete-a-user
      def delete(user)
        client.delete("1.0/users/#{user}")
      end

      # Get next user tracks
      #
      # @see http://api.niland.io/1.0/doc/users#get-next-user-tracks
      def get_next(user)
        response = client.get("1.0/users/#{user}/next")
        response.map { |user| Struct::User.new(response) }
      end

      # Get liked tracks.
      #
      # @see https://api.niland.io/doc/users#get-liked-tracks
      def get_liked_tracks(user)
        response = client.get("1.0/users/#{user}/likes")
        response.map { |track| Struct::Track.new(track) }
      end

      # Add liked tracks.
      #
      # @see https://api.niland.io/doc/users#add-liked-track
      def add_liked_track(user, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("1.0/users/#{user}/likes", attributes)
        Struct::Track.new(response)
      end

      # Get disliked tracks.
      #
      # @see https://api.niland.io/doc/users#get-disliked-tracks
      def get_disliked_tracks(user)
        response = client.get("1.0/users/#{user}/dislikes")
        response.map { |track| Struct::Track.new(track) }
      end

      # Add disliked tracks.
      #
      # @see https://api.niland.io/doc/users#add-disliked-track
      def add_disliked_track(user, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("1.0/users/#{user}/dislikes", attributes)
        Struct::Track.new(response)
      end
    end
  end
end
