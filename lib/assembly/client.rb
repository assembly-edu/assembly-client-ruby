# encoding: utf-8

#
# WARNING: Do not edit by hand, this file was generated by Heroics:
#
#   https://github.com/interagent/heroics
#

require 'heroics'
require 'uri'

module Assembly
  # Get a Client configured to use HTTP Basic authentication.
  #
  # @param api_key [String] The API key to use when connecting.
  # @param options [Hash<Symbol,String>] Optionally, custom settings
  #   to use with the client.  Allowed options are `default_headers`,
  #   `cache`, `user` and `url`.
  # @return [Client] A client configured to use the API with HTTP Basic
  #   authentication.
  def self.connect(api_key, options=nil)
    options = custom_options(options)
    uri = URI.parse(options[:url])
    uri.user = URI.encode_www_form_component options.fetch(:user, 'user')
    uri.password = api_key
    client = Heroics.client_from_schema(SCHEMA, uri.to_s, options)
    Client.new(client)
  end

  # Get a Client configured to use OAuth authentication.
  #
  # @param oauth_token [String] The OAuth token to use with the API.
  # @param options [Hash<Symbol,String>] Optionally, custom settings
  #   to use with the client.  Allowed options are `default_headers`,
  #   `cache` and `url`.
  # @return [Client] A client configured to use the API with OAuth
  #   authentication.
  def self.connect_oauth(oauth_token, options=nil)
    options = custom_options(options)
    url = options[:url]
    client = Heroics.oauth_client_from_schema(oauth_token, SCHEMA, url, options)
    Client.new(client)
  end

  # Get a Client configured to use Token authentication.
  #
  # @param token [String] The token to use with the API.
  # @param options [Hash<Symbol,String>] Optionally, custom settings
  #   to use with the client.  Allowed options are `default_headers`,
  #   `cache` and `url`.
  # @return [Client] A client configured to use the API with OAuth
  #   authentication.
  def self.connect_token(token, options=nil)
    options = custom_options(options)
    url = options[:url]
    client = Heroics.token_client_from_schema(token, SCHEMA, url, options)
    Client.new(client)
  end

  # Get customized options.
  def self.custom_options(options)
    return default_options if options.nil?

    final_options = default_options
    if options[:default_headers]
      final_options[:default_headers].merge!(options[:default_headers])
    end
    final_options[:cache] = options[:cache] if options[:cache]
    final_options[:url] = options[:url] if options[:url]
    final_options[:user] = options[:user] if options[:user]
    final_options
  end

  # Get the default options.
  def self.default_options
    default_headers = {"Accept"=>"application/json"}
    cache = Moneta.new(:Memory)
    {
      default_headers: default_headers,
      cache:           cache,
      url:             "http://platform.assembly.education"
    }
  end

  private_class_method :default_options, :custom_options

  # API access to education data.
  class Client
    def initialize(client)
      @client = client
    end

    # Represents a point where assessments take place.
    #
    # @return [AssessmentPoint]
    def assessment_point
      @assessment_point_resource ||= AssessmentPoint.new(@client)
    end

    # A Grade Set groups a set of commonly scaled grades for comparison.
    #
    # @return [GradeSet]
    def grade_set
      @grade_set_resource ||= GradeSet.new(@client)
    end
  end

  private

  # Represents a point where assessments take place.
  class AssessmentPoint
    def initialize(client)
      @client = client
    end

    # Create a new assessment_point.
    #
    # @param body: the object to pass as the request payload
    def create(body)
      @client.assessment_point.create(body)
    end

    # Delete an existing assessment_point.
    #
    # @param assessment_point_identity: 
    def delete(assessment_point_identity)
      @client.assessment_point.delete(assessment_point_identity)
    end

    # Info for existing assessment_point.
    #
    # @param assessment_point_identity: 
    def info(assessment_point_identity)
      @client.assessment_point.info(assessment_point_identity)
    end

    # List existing assessment_points.
    def update()
      @client.assessment_point.update()
    end
  end

  # A Grade Set groups a set of commonly scaled grades for comparison.
  class GradeSet
    def initialize(client)
      @client = client
    end

    # Create a new grade_set.
    #
    # @param body: the object to pass as the request payload
    def create(body)
      @client.grade_set.create(body)
    end

    # Info for existing grade_set.
    #
    # @param grade_set_identity: 
    def info(grade_set_identity)
      @client.grade_set.info(grade_set_identity)
    end
  end

  SCHEMA = Heroics::Schema.new(MultiJson.load(<<-'HEROICS_SCHEMA'))
{
  "$schema": "http://interagent.github.io/interagent-hyper-schema",
  "type": [
    "object"
  ],
  "definitions": {
    "assessment-point": {
      "$schema": "http://json-schema.org/draft-04/hyper-schema",
      "title": "Assessment Point",
      "description": "Represents a point where assessments take place.",
      "stability": "prototype",
      "strictProperties": true,
      "type": [
        "object"
      ],
      "definitions": {
        "id": {
          "description": "unique identifier",
          "readOnly": true,
          "type": [
            "integer"
          ]
        },
        "name": {
          "description": "human readable name",
          "readOnly": false,
          "type": [
            "string"
          ]
        },
        "identity": {
          "$ref": "#/definitions/assessment-point/definitions/id"
        },
        "created_at": {
          "description": "when assessment_point was created",
          "format": "date-time",
          "type": [
            "string"
          ]
        },
        "updated_at": {
          "description": "when assessment_point was last updated",
          "format": "date-time",
          "type": [
            "string"
          ]
        }
      },
      "links": [
        {
          "description": "Create a new assessment_point.",
          "href": "/api/assessment_points",
          "method": "POST",
          "rel": "create",
          "schema": {
            "properties": {
            },
            "type": [
              "object"
            ]
          },
          "title": "Create"
        },
        {
          "description": "Delete an existing assessment_point.",
          "href": "/api/assessment_points/{(%23%2Fdefinitions%2Fassessment-point%2Fdefinitions%2Fidentity)}",
          "method": "DELETE",
          "rel": "destroy",
          "title": "Delete"
        },
        {
          "description": "Info for existing assessment_point.",
          "href": "/api/assessment_points/{(%23%2Fdefinitions%2Fassessment-point%2Fdefinitions%2Fidentity)}",
          "method": "GET",
          "rel": "self",
          "title": "Info"
        },
        {
          "description": "List existing assessment_points.",
          "href": "/api/assessment_points",
          "method": "GET",
          "rel": "instances",
          "title": "Update"
        }
      ],
      "properties": {
        "created_at": {
          "$ref": "#/definitions/assessment-point/definitions/created_at"
        },
        "id": {
          "$ref": "#/definitions/assessment-point/definitions/id"
        },
        "name": {
          "$ref": "#/definitions/assessment-point/definitions/name"
        },
        "updated_at": {
          "$ref": "#/definitions/assessment-point/definitions/updated_at"
        }
      }
    },
    "grade-set": {
      "$schema": "http://json-schema.org/draft-04/hyper-schema",
      "title": "Grade Set",
      "description": "A Grade Set groups a set of commonly scaled grades for comparison.",
      "stability": "prototype",
      "strictProperties": true,
      "type": [
        "object"
      ],
      "definitions": {
        "id": {
          "description": "unique identifier",
          "readOnly": true,
          "type": [
            "integer"
          ]
        },
        "name": {
          "description": "human readable name",
          "readOnly": false,
          "type": [
            "string"
          ]
        },
        "identity": {
          "$ref": "#/definitions/grade-set/definitions/id"
        },
        "created_at": {
          "description": "when grade_set was created",
          "format": "date-time",
          "type": [
            "string"
          ]
        },
        "updated_at": {
          "description": "when grade_set was updated",
          "format": "date-time",
          "type": [
            "string"
          ]
        },
        "grades": {
          "description": "list of grades",
          "type": [
            "array"
          ],
          "items": {
            "$ref": "#/definitions/grade-set/definitions/grade"
          }
        },
        "grade": {
          "description": "represents a scaled grade",
          "type": [
            "object"
          ],
          "properties": {
            "name": {
              "$ref": "#/definitions/grade-set/definitions/grade_name"
            },
            "value": {
              "$ref": "#/definitions/grade-set/definitions/grade_value"
            }
          },
          "required": [
            "grade_name",
            "grade_value"
          ]
        },
        "grade_name": {
          "description": "the commonally used human name for this grade",
          "readOnly": false,
          "type": [
            "string"
          ]
        },
        "grade_value": {
          "description": "the scaled point value for this grade",
          "readOnly": false,
          "type": [
            "integer"
          ]
        }
      },
      "links": [
        {
          "description": "Create a new grade_set.",
          "href": "/api/grade_sets",
          "method": "POST",
          "rel": "create",
          "schema": {
            "properties": {
            },
            "type": [
              "object"
            ]
          },
          "title": "Create"
        },
        {
          "description": "Info for existing grade_set.",
          "href": "/api/grade_sets/{(%23%2Fdefinitions%2Fgrade-set%2Fdefinitions%2Fidentity)}",
          "method": "GET",
          "rel": "self",
          "title": "Info"
        }
      ],
      "properties": {
        "created_at": {
          "$ref": "#/definitions/grade-set/definitions/created_at"
        },
        "id": {
          "$ref": "#/definitions/grade-set/definitions/id"
        },
        "name": {
          "$ref": "#/definitions/grade-set/definitions/name"
        },
        "updated_at": {
          "$ref": "#/definitions/grade-set/definitions/updated_at"
        },
        "grades": {
          "$ref": "#/definitions/grade-set/definitions/grades"
        }
      }
    }
  },
  "properties": {
    "assessment-point": {
      "$ref": "#/definitions/assessment-point"
    },
    "grade-set": {
      "$ref": "#/definitions/grade-set"
    }
  },
  "id": "assembly-education",
  "title": "Project Assembly API",
  "description": "API access to education data.",
  "links": [
    {
      "href": "https://assembly.education",
      "rel": "self"
    }
  ]
}
HEROICS_SCHEMA
end
