class ConfsController < ApplicationController

  def index
    Conf.loadConfs

    @conf = Hash.new
    Conf.integer_accepted_values.each do |conf|
      @conf[conf] = Conf.value(conf)
    end
    Conf.double_accepted_values.each do |conf|
      @conf[conf] = Conf.value(conf)
    end
    Conf.text_accepted_values.each do |conf|
      @conf[conf] = Conf.value(conf)
    end
    respond_to do |format|
      format.html
    end
  end

  def edit
    Conf.loadConfs

    @conf = Hash.new
    Conf.integer_accepted_values.each do |conf|
      @conf[conf] = Conf.value(conf)
    end
    Conf.double_accepted_values.each do |conf|
      @conf[conf] = Conf.value(conf)
    end
    Conf.text_accepted_values.each do |conf|
      @conf[conf] = Conf.value(conf)
    end
  end

  def update
    Conf.integer_accepted_values.each do |conf|
      if new_value = params["#{conf}"]
        new_value = new_value.to_i
        if set = Conf.find_by_code(conf)
          if set.number_value != new_value
            set.number_value = new_value
            set.save
          end
        else
          Conf.create(code: conf, number_value: new_value)
        end
      end
    end
    Conf.double_accepted_values.each do |conf|
      if new_value = params["#{conf}"]
        new_value = new_value.sub(",",".").to_d
        if set = Conf.find_by_code(conf)
          if set.number_value != new_value
            set.number_value = new_value
            set.save
          end
        else
          Conf.create(code: conf, number_value: new_value)
        end
      end
    end
    Conf.text_accepted_values.each do |conf|
      if new_value = params["#{conf}"]
        if set = Conf.find_by_code(conf)
          if set.text_value != new_value
            set.text_value = new_value
            set.save
          end
        else
          Conf.create(code: conf, text_value: new_value)
        end
      end
    end

    Conf.loadConfs

    respond_to do |format|
      format.html { redirect_to confs_path, notice: "Guardado correctamente" }
    end
  end

end
