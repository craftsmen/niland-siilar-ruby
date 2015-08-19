module Siilar
  class Client
    module Tags
      
      # Get all the tag collections
      #
      # @see http://api.siilar.com/1.0/doc/tags#list-tag-collections
      def tag_collections
        response = client.get('1.0/tag-collections')

        response.map { |r| Struct::TagCollection.new(r) }
      end

      # Get one tag collection
      #
      # @see http://api.siilar.com/1.0/doc/tags#get-tag-collections
      def tag_collection(collection)
        response = client.get("1.0/tag-collections/#{collection}")

        Struct::TagCollection.new(response)
      end

      # Create a tag collection
      #
      # @see http://api.siilar.com/1.0/doc/tags#create-tag-collections
      def create_tag_collection(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:name])
        response = client.post('1.0/tag-collections', attributes)

        Struct::TagCollection.new(response)
      end

      # Edit a tag collection
      #
      # @see http://api.siilar.com/1.0/doc/tags#edit-tag-collections
      def edit_tag_collection(collection, attributes = {})
        response = client.patch("1.0/tag-collections/#{collection}", attributes)

        Struct::TagCollection.new(response)
      end

      # Delete a tag collection
      #
      # @see http://api.siilar.com/1.0/doc/tags#delete-tag-collections
      def delete_tag_collection(collection)
        client.delete("1.0/tag-collections/#{collection}")
      end
      
      # Find tags
      #
      # @see http://api.siilar.com/1.0/doc/tags#find-tags
      def find_tags(attributes = {})
        response = client.get('1.0/tags', attributes)

        Struct::Tag.new(response)
      end
    end
  end
end
