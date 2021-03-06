class Kynort::Flights::Passenger
  attr_accessor :title
  attr_accessor :phone
  attr_accessor :passport
  attr_accessor :first_name
  attr_accessor :middle_name
  attr_accessor :last_name
  attr_accessor :born_day
  attr_accessor :born_month
  attr_accessor :born_year
  attr_accessor :nationality

  attr_accessor :is_adult
  attr_accessor :is_child
  attr_accessor :is_infant

  alias_method :is_adult?, :is_adult
  alias_method :is_child?, :is_child
  alias_method :is_infant?, :is_infant

  attr_accessor :associated_adult

  def born_month=(val)
    @born_month = Integer val
  rescue => e
    @born_month = val
  end

  def born_year=(val)
    @born_year = Integer val
  rescue => e
    @born_year = val
  end

  def born_day=(val)
    @born_day = Integer val
  rescue => e
    @born_day = val
  end

  def validate
    errors = []
    errors << "Title must be either Mr/Ms/Mrs" unless [Kynort::TITLE_MISTER, Kynort::TITLE_MS, Kynort::TITLE_MRS].include?(title)
    errors << "First name cannot be blank" if first_name.nil? || first_name.blank?
    errors << "Born month must be an integer" if born_month.nil? || born_month.blank? || !born_month.is_a?(Integer)
    errors << "Born day must be an integer" if born_day.nil? || born_day.blank? || !born_day.is_a?(Integer)
    errors << "Born year must be an integer" if born_year.nil? || born_year.blank? || !born_year.is_a?(Integer)
    errors << "Born day must be between 1 to 31" unless (1..31).include?(born_day)
    errors << "Born month must be between 1 to 12" unless (1..12).include?(born_month)
    errors << "Must be either an adult (#{is_adult}), a child (#{is_child}), or an infant (#{is_infant})"  if \
        (is_adult && (is_child || is_infant)) || (is_child && (is_adult || is_infant)) || \
        (is_infant && (is_adult || is_child))
    errors << "is_adult must be a boolean" if is_adult && !(is_adult.is_a?(TrueClass) || is_adult.is_a?(FalseClass))
    errors << "is_child must be a boolean" if is_child && !(is_child.is_a?(TrueClass) || is_child.is_a?(FalseClass))
    errors << "is_infant must be a boolean" if is_infant && !(is_infant.is_a?(TrueClass) || is_infant.is_a?(FalseClass))
    errors << "associated_adult must be an adult" if is_infant && (associated_adult.nil? || \
       !associated_adult.is_a?(Kynort::Flights::Passenger) || !associated_adult.is_adult)
    errors
  end

  def validate!
    errors = validate
    raise errors[0] if errors.any?
  end

  def nationality=(value)
    raise "the nationality of #{first_name} cannot be processed, maybe wrong name?" if Kynort::NormalizeCountry.convert(value).nil?
    @nationality = value
  end

  def is_adult=(val)
    @is_child = false
    @is_infant = false
    @is_adult = val
  end

  def is_child=(val)
    @is_child = val
    @is_infant = false
    @is_adult = false
  end

  def is_infant=(val)
    @is_child = false
    @is_infant = val
    @is_adult = false
  end
end