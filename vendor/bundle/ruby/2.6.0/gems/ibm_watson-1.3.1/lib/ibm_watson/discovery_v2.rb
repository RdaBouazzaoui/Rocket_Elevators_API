# frozen_string_literal: true

# (C) Copyright IBM Corp. 2019, 2020.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# IBM Watson&trade; Discovery for IBM Cloud Pak for Data is a cognitive search and
# content analytics engine that you can add to applications to identify patterns, trends
# and actionable insights to drive better decision-making. Securely unify structured and
# unstructured data with pre-enriched content, and use a simplified query language to
# eliminate the need for manual filtering of results.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Discovery V2 service.
  class DiscoveryV2 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Discovery service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] The API version date to use with the service, in
    #   "YYYY-MM-DD" format. Whenever the API is changed in a backwards
    #   incompatible way, a new minor version of the API is released.
    #   The service uses the API version for the date you specify, or
    #   the most recent version before that date. Note that you should
    #   not programmatically specify the current date at runtime, in
    #   case the API has been updated since your application's release.
    #   Instead, specify a version date that is compatible with your
    #   application, and don't change it until your application is
    #   ready for a later version.
    # @option args service_url [String] The base service URL to use when contacting the service.
    #   The base service_url may differ between IBM Cloud regions.
    # @option args authenticator [Object] The Authenticator instance to be configured for this service.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:version] = nil
      defaults[:service_url] = nil
      defaults[:authenticator] = nil
      args = defaults.merge(args)
      @version = args[:version]
      raise ArgumentError.new("version must be provided") if @version.nil?

      args[:service_name] = "discovery"
      args[:authenticator] = IBMCloudSdkCore::ConfigBasedAuthenticatorFactory.new.get_authenticator(service_name: args[:service_name]) if args[:authenticator].nil?
      super
    end

    #########################
    # Collections
    #########################

    ##
    # @!method list_collections(project_id:)
    # List collections.
    # Lists existing collections for the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_collections(project_id:)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_collections")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/collections" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Queries
    #########################

    ##
    # @!method query(project_id:, collection_ids: nil, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, _return: nil, offset: nil, sort: nil, highlight: nil, spelling_suggestions: nil, table_results: nil, suggested_refinements: nil, passages: nil)
    # Query a project.
    # By using this method, you can construct queries. For details, see the [Discovery
    #   documentation](https://cloud.ibm.com/docs/services/discovery-data?topic=discovery-data-query-concepts).
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param collection_ids [Array[String]] A comma-separated list of collection IDs to be queried against.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param aggregation [String] An aggregation search that returns an exact answer by combining query search with
    #   filters. Useful for applications to build lists, tables, and time series. For a
    #   full list of possible aggregations, see the Query reference.
    # @param count [Fixnum] Number of results to return.
    # @param _return [Array[String]] A list of the fields in the document hierarchy to return. If this parameter not
    #   specified, then all top-level fields are returned.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results.
    # @param sort [String] A comma-separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified. This
    #   parameter cannot be used in the same query as the **bias** parameter.
    # @param highlight [Boolean] When `true`, a highlight field is returned for each result which contains the
    #   fields which match the query with `<em></em>` tags around the matching query
    #   terms.
    # @param spelling_suggestions [Boolean] When `true` and the **natural_language_query** parameter is used, the
    #   **natural_language_query** parameter is spell checked. The most likely correction
    #   is returned in the **suggested_query** field of the response (if one exists).
    # @param table_results [QueryLargeTableResults] Configuration for table retrieval.
    # @param suggested_refinements [QueryLargeSuggestedRefinements] Configuration for suggested refinements.
    # @param passages [QueryLargePassages] Configuration for passage retrieval.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query(project_id:, collection_ids: nil, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, _return: nil, offset: nil, sort: nil, highlight: nil, spelling_suggestions: nil, table_results: nil, suggested_refinements: nil, passages: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "collection_ids" => collection_ids,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "aggregation" => aggregation,
        "count" => count,
        "return" => _return,
        "offset" => offset,
        "sort" => sort,
        "highlight" => highlight,
        "spelling_suggestions" => spelling_suggestions,
        "table_results" => table_results,
        "suggested_refinements" => suggested_refinements,
        "passages" => passages
      }

      method_url = "/v2/projects/%s/query" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_autocompletion(project_id:, prefix:, collection_ids: nil, field: nil, count: nil)
    # Get Autocomplete Suggestions.
    # Returns completion query suggestions for the specified prefix.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param prefix [String] The prefix to use for autocompletion. For example, the prefix `Ho` could
    #   autocomplete to `Hot`, `Housing`, or `How do I upgrade`. Possible completions are.
    # @param collection_ids [Array[String]] Comma separated list of the collection IDs. If this parameter is not specified,
    #   all collections in the project are used.
    # @param field [String] The field in the result documents that autocompletion suggestions are identified
    #   from.
    # @param count [Fixnum] The number of autocompletion suggestions to return.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_autocompletion(project_id:, prefix:, collection_ids: nil, field: nil, count: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("prefix must be provided") if prefix.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_autocompletion")
      headers.merge!(sdk_headers)
      collection_ids *= "," unless collection_ids.nil?

      params = {
        "version" => @version,
        "prefix" => prefix,
        "collection_ids" => collection_ids,
        "field" => field,
        "count" => count
      }

      method_url = "/v2/projects/%s/autocompletion" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method query_notices(project_id:, filter: nil, query: nil, natural_language_query: nil, count: nil, offset: nil)
    # Query system notices.
    # Queries for notices (errors or warnings) that might have been generated by the
    #   system. Notices are generated when ingesting documents and performing relevance
    #   training.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param count [Fixnum] Number of results to return. The maximum for the **count** and **offset** values
    #   together in any one query is **10000**.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results. The maximum for the **count** and **offset** values together in any
    #   one query is **10000**.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query_notices(project_id:, filter: nil, query: nil, natural_language_query: nil, count: nil, offset: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "query_notices")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "count" => count,
        "offset" => offset
      }

      method_url = "/v2/projects/%s/notices" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_fields(project_id:, collection_ids: nil)
    # List fields.
    # Gets a list of the unique fields (and their types) stored in the the specified
    #   collections.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param collection_ids [Array[String]] Comma separated list of the collection IDs. If this parameter is not specified,
    #   all collections in the project are used.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_fields(project_id:, collection_ids: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_fields")
      headers.merge!(sdk_headers)
      collection_ids *= "," unless collection_ids.nil?

      params = {
        "version" => @version,
        "collection_ids" => collection_ids
      }

      method_url = "/v2/projects/%s/fields" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Component settings
    #########################

    ##
    # @!method get_component_settings(project_id:)
    # Configuration settings for components.
    # Returns default configuration settings for components.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_component_settings(project_id:)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_component_settings")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/component_settings" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Documents
    #########################

    ##
    # @!method add_document(project_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
    # Add a document.
    # Add a document to a collection with optional metadata.
    #
    #    Returns immediately after the system has accepted the document for processing.
    #
    #     * The user must provide document content, metadata, or both. If the request is
    #   missing both document content and metadata, it is rejected.
    #
    #     * The user can set the **Content-Type** parameter on the **file** part to
    #   indicate the media type of the document. If the **Content-Type** parameter is
    #   missing or is one of the generic media types (for example,
    #   `application/octet-stream`), then the service attempts to automatically detect the
    #   document's media type.
    #
    #     * The following field names are reserved and will be filtered out if present
    #   after normalization: `id`, `score`, `highlight`, and any field with the prefix of:
    #   `_`, `+`, or `-`
    #
    #     * Fields with empty name values after normalization are filtered out before
    #   indexing.
    #
    #     * Fields containing the following characters after normalization are filtered
    #   out before indexing: `#` and `,`
    #
    #     If the document is uploaded to a collection that has it's data shared with
    #   another collection, the **X-Watson-Discovery-Force** header must be set to `true`.
    #
    #
    #    **Note:** Documents can be added with a specific **document_id** by using the
    #   **_/v2/projects/{project_id}/collections/{collection_id}/documents** method.
    #
    #   **Note:** This operation only works on collections created to accept direct file
    #   uploads. It cannot be used to modify a collection that connects to an external
    #   source such as Microsoft SharePoint.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param collection_id [String] The ID of the collection.
    # @param file [File] The content of the document to ingest. The maximum supported file size when adding
    #   a file to a collection is 50 megabytes, the maximum supported file size when
    #   testing a configuration is 1 megabyte. Files larger than the supported size are
    #   rejected.
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected. Example:  ``` {
    #     "Creator": "Johnny Appleseed",
    #     "Subject": "Apples"
    #   } ```.
    # @param x_watson_discovery_force [Boolean] When `true`, the uploaded document is added to the collection even if the data for
    #   that collection is shared with other collections.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def add_document(project_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
        "X-Watson-Discovery-Force" => x_watson_discovery_force
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "add_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless file.nil?
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        filename = file.path if filename.nil? && file.respond_to?(:path)
        form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: filename)
      end

      form_data[:metadata] = HTTP::FormData::Part.new(metadata.to_s, content_type: "text/plain") unless metadata.nil?

      method_url = "/v2/projects/%s/collections/%s/documents" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method update_document(project_id:, collection_id:, document_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
    # Update a document.
    # Replace an existing document or add a document with a specified **document_id**.
    #   Starts ingesting a document with optional metadata.
    #
    #   If the document is uploaded to a collection that has it's data shared with another
    #   collection, the **X-Watson-Discovery-Force** header must be set to `true`.
    #
    #   **Note:** When uploading a new document with this method it automatically replaces
    #   any document stored with the same **document_id** if it exists.
    #
    #   **Note:** This operation only works on collections created to accept direct file
    #   uploads. It cannot be used to modify a collection that connects to an external
    #   source such as Microsoft SharePoint.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @param file [File] The content of the document to ingest. The maximum supported file size when adding
    #   a file to a collection is 50 megabytes, the maximum supported file size when
    #   testing a configuration is 1 megabyte. Files larger than the supported size are
    #   rejected.
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected. Example:  ``` {
    #     "Creator": "Johnny Appleseed",
    #     "Subject": "Apples"
    #   } ```.
    # @param x_watson_discovery_force [Boolean] When `true`, the uploaded document is added to the collection even if the data for
    #   that collection is shared with other collections.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_document(project_id:, collection_id:, document_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
        "X-Watson-Discovery-Force" => x_watson_discovery_force
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "update_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless file.nil?
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        filename = file.path if filename.nil? && file.respond_to?(:path)
        form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: filename)
      end

      form_data[:metadata] = HTTP::FormData::Part.new(metadata.to_s, content_type: "text/plain") unless metadata.nil?

      method_url = "/v2/projects/%s/collections/%s/documents/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(document_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_document(project_id:, collection_id:, document_id:, x_watson_discovery_force: nil)
    # Delete a document.
    # If the given document ID is invalid, or if the document is not found, then the a
    #   success response is returned (HTTP status code `200`) with the status set to
    #   'deleted'.
    #
    #   **Note:** This operation only works on collections created to accept direct file
    #   uploads. It cannot be used to modify a collection that connects to an external
    #   source such as Microsoft SharePoint.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @param x_watson_discovery_force [Boolean] When `true`, the uploaded document is added to the collection even if the data for
    #   that collection is shared with other collections.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_document(project_id:, collection_id:, document_id:, x_watson_discovery_force: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
        "X-Watson-Discovery-Force" => x_watson_discovery_force
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/collections/%s/documents/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(document_id)]

      response = request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Training data
    #########################

    ##
    # @!method list_training_queries(project_id:)
    # List training queries.
    # List the training queries for the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_training_queries(project_id:)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_training_queries")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/training_data/queries" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_training_queries(project_id:)
    # Delete training queries.
    # Removes all training queries for the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @return [nil]
    def delete_training_queries(project_id:)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_training_queries")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/training_data/queries" % [ERB::Util.url_encode(project_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end

    ##
    # @!method create_training_query(project_id:, natural_language_query:, examples:, filter: nil)
    # Create training query.
    # Add a query to the training data for this project. The query can contain a filter
    #   and natural language query.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param natural_language_query [String] The natural text query for the training query.
    # @param examples [Array[TrainingExample]] Array of training examples.
    # @param filter [String] The filter used on the collection before the **natural_language_query** is
    #   applied.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_training_query(project_id:, natural_language_query:, examples:, filter: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("natural_language_query must be provided") if natural_language_query.nil?

      raise ArgumentError.new("examples must be provided") if examples.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "create_training_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "natural_language_query" => natural_language_query,
        "examples" => examples,
        "filter" => filter
      }

      method_url = "/v2/projects/%s/training_data/queries" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_training_query(project_id:, query_id:)
    # Get a training data query.
    # Get details for a specific training data query, including the query string and all
    #   examples.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param query_id [String] The ID of the query used for training.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_training_query(project_id:, query_id:)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_training_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/training_data/queries/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(query_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method update_training_query(project_id:, query_id:, natural_language_query:, examples:, filter: nil)
    # Update a training query.
    # Updates an existing training query and it's examples.
    # @param project_id [String] The ID of the project. This information can be found from the deploy page of the
    #   Discovery administrative tooling.
    # @param query_id [String] The ID of the query used for training.
    # @param natural_language_query [String] The natural text query for the training query.
    # @param examples [Array[TrainingExample]] Array of training examples.
    # @param filter [String] The filter used on the collection before the **natural_language_query** is
    #   applied.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_training_query(project_id:, query_id:, natural_language_query:, examples:, filter: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      raise ArgumentError.new("natural_language_query must be provided") if natural_language_query.nil?

      raise ArgumentError.new("examples must be provided") if examples.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "update_training_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "natural_language_query" => natural_language_query,
        "examples" => examples,
        "filter" => filter
      }

      method_url = "/v2/projects/%s/training_data/queries/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(query_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end
  end
end
