module Assembly
  module Util
    def self.underscore(str)
      str.scan(/[A-Z][a-z]*/).join("_").downcase
    end

    def self.models
      {
        list: List,
        assessment: Assessment,
        assessment_point: AssessmentPoint,
        calendar_event: CalendarEvent,
        contact: Contact,
        grade_set: GradeSet,
        grade: Grade,
        aspect: Aspect,
        registration_group: RegistrationGroup,
        result: Result,
        teaching_group: TeachingGroup,
        school_detail: SchoolDetail,
        staff_member: StaffMember,
        student: Student,
        subject: Subject,
      }
    end

    def self.build(response, client=nil)
      case response
      when Hash
        klass = response.has_key?(:object) ? models.fetch(response[:object].to_sym, ApiModel) : Model
        klass.construct_from(response, client)
      when Array
        response.map {|o| Util.build(o, client) }
      else
        response
      end
    end
  end
end
