module Siilar
  class Client
    module Users

      # Get a list of your users.
      #
      # @see http://api.niland.io/2.0/doc/users#list-users
      def list(query = {})
        response = client.get('users')
        response['data'].map { |user| Struct::User.new(user) }
      end

      # Get a user.
      #
      # @see http://api.niland.io/2.0/doc/users#get-a-user
      def get(user)
        response = client.get("users/#{user}")
        Struct::User.new(response)
      end

      # Create a user.
      #
      # @see http://api.niland.io/2.0/doc/users#create-a-user
      def create(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:reference])
        response = client.post('users', attributes)
        Struct::User.new(response)
      end

      # Update a user.
      #
      # @see http://api.niland.io/2.0/doc/users#edit-a-user
      def update(user, attributes = {})
        response = client.patch("users/#{user}", attributes)
        Struct::User.new(response)
      end

      # Delete a user.
      #
      # @see http://api.niland.io/2.0/doc/users#delete-a-user
      def delete(user)
        client.delete("users/#{user}")
      end

      # Get user likes
      #
      # @see http://api.niland.io/2.0/doc/users#get-user-likes
      def get_likes(user)
        response = client.get("users/#{user}/likes")
        response['data'].map { |track| Struct::Track.new(track) }
      end

      # Add a user like.
      #
      # @see https://api.niland.io/doc/users#add-a-user-like
      def add_like(user, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("users/#{user}/likes", attributes)
        Struct::Track.new(response['track'])
      end

      # Get user dislikes
      #
      # @see http://api.niland.io/2.0/doc/users#get-user-dislikes
      def get_dislikes(user)
        response = client.get("users/#{user}/dislikes")
        response['data'].map { |track| Struct::Track.new(track) }
      end

      # Add a user dislike.
      #
      # @see https://api.niland.io/doc/users#add-a-user-dislike
      def add_dislike(user, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:track])
        response = client.post("users/#{user}/dislikes", attributes)
        Struct::Track.new(response['track'])
      end
    end
  end
end
