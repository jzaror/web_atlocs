class Conf < ActiveRecord::Base

  validates :code, uniqueness: true

  @@configs = nil

  def self.integer_accepted_values
    []
  end
  def self.double_accepted_values
    []
  end
  def self.text_accepted_values
    ['admin_email', 'client_review', 'owner_review']
  end

  def self.value(code)
    code = code.to_s
    unless @@configs
      Conf.loadConfs
    end
    if c = @@configs[code] # Podría validarse de forma distinta. Por ej @@configs[code].exists?
      c.value
    else
      if Conf.integer_accepted_values.include? code
        0
      elsif Conf.double_accepted_values.include? code
        0
      elsif Conf.text_accepted_values.include? code
        ""
      else
        nil
      end
    end
  end

  def value
    if Conf.integer_accepted_values.include? self.code
      self.number_value.to_i
    elsif Conf.double_accepted_values.include? self.code
      self.number_value
    elsif Conf.text_accepted_values.include? self.code
      self.text_value
    else
      nil
    end
  end

  def self.loadConfs
    @@configs = Hash.new
    Conf.all.each do |c|
      @@configs[c.code] = c
    end
  end
end
