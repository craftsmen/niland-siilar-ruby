module Siilar
  class Client
    module Tags
      
      # list or find tag collections
      #
      # @see http://api.niland.io/2.0/doc/tags#list-or-find-tag-collections
      def tag_collections(query = {})
        options = { query: query }
        response = client.get('2.0/tag-collections', options)

        response['data'].map { |r| Struct::TagCollection.new(r) }
      end

      # Get one tag collection
      #
      # @see http://api.niland.io/2.0/doc/tags#get-a-tag-collection
      def tag_collection(collection)
        response = client.get("2.0/tag-collections/#{collection}")

        Struct::TagCollection.new(response)
      end

      # Create a tag collection
      #
      # @see http://api.niland.io/2.0/doc/tags#create-a-tag-collection
      def create_tag_collection(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:name])
        response = client.post('2.0/tag-collections', attributes)

        Struct::TagCollection.new(response)
      end

      # Edit a tag collection
      #
      # @see http://api.niland.io/2.0/doc/tags#edit-a-tag-collection
      def edit_tag_collection(collection, attributes = {})
        response = client.patch("2.0/tag-collections/#{collection}", attributes)

        Struct::TagCollection.new(response)
      end

      # Delete a tag collection
      #
      # @see http://api.niland.io/2.0/doc/tags#delete-a-tag-collection
      def delete_tag_collection(collection)
        client.delete("2.0/tag-collections/#{collection}")
      end
      
      # list or find tags
      #
      # @see http://api.niland.io/2.0/doc/tags#list-or-find-tags
      def find_tags(query = {})
        options = { query: query }
        response = client.get('2.0/tags', options)

        response['data'].map { |tag| Struct::Tag.new(tag) }
      end

      # Get one tag
      #
      # @see http://api.niland.io/2.0/doc/tags#get-a-tag
      def tag(tag)
        response = client.get("2.0/tags/#{tag}")

        Struct::Tag.new(response)
      end

      # Create a tag
      #
      # @see http://api.niland.io/2.0/doc/tags#create-a-tag
      def create_tag(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:title, :tag_collection])
        response = client.post('2.0/tag-collections', attributes)

        Struct::Tag.new(response)
      end

      # Edit a tag
      #
      # @see http://api.niland.io/2.0/doc/tags#edit-a-tag
      def edit_tag(tag, attributes = {})
        response = client.patch("2.0/tags/#{tag}", attributes)

        Struct::Tag.new(response)
      end

      # Delete a tag
      #
      # @see http://api.niland.io/2.0/doc/tags#delete-a-tag
      def delete_tag(tag)
        client.delete("2.0/tags/#{tag}")
      end

    end
  end
end
