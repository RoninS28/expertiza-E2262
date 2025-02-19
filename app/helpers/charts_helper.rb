# frozen_string_literal: true

module ChartsHelper
  # labels: array of labels
  # values: array of values
  def self.get_pie_chart_url(labels, values)
    return  '' if labels.length != values.length

    address = 'http://chart.apis.google.com/chart?cht=p3&chs=300x125'
    max = 100.0
    values.each do |value|
      max = value if value.to_f > max
    end

    max /= 100.0

    value_string = '&chd=t:'
    label_string = '&chl='
    color_string = '&chco='

    i = 0
    values.each do |value|
      unless value == 0

        value_string += (value.to_f / max).to_i.to_s + ','
        label_string += labels[i].to_s + '|'
        color_string += get_rg_color(i + 0.5, values.length) + ','
      end
      i += 1
    end

    value_string = value_string[0..-2]   # remove last comma
    label_string = label_string[0..-2]   # remove last "|"
    color_string = color_string[0..-2]   # remove last comma

    address += value_string + label_string + color_string
    address
  end

  # labels: array of labels
  # values: array of values
  # max:    maximum possible value
  def self.get_bar_chart_url(labels, values, max)
    return  '' if labels.length != values.length

    address = 'http://chart.apis.google.com/chart?cht=bhs&chxt=x,y&chf=bg,s,dddddd&chtt=Average+response+score+by+question&chs=600x' + (labels.length * 25 + 60).to_s

    value_string = '&chd=t:'
    label_string = '&chxl=0:|'
    color_string = '&chco='

    (0..max).each do |j|
      label_string += j.to_s + '|'
    end

    label_string += '1:|'

    i = 0
    values.each do |value|
      label_string += labels[labels.length - 1 - i].to_s + '|'
      color_string += get_rg_color(value, max) + ','
      value_string += (value * 100 / max).to_i.to_s + ','
      i += 1
    end

    value_string = value_string[0..-2]   # remove last "|"
    label_string = label_string[0..-2]   # remove last "|"
    color_string = color_string[0..-2]   # remove last comma

    address += value_string + label_string + color_string
    address
  end

  def self.get_rg_color(value, max)
    ratio = value / (max / 2.0)
    color = ''

    if ratio < 1.0
      level = format('%02x', 256 * ratio)
      color = 'ff' + level + level
    elsif ratio == 1.0
      color = 'ffffff'
    else
      level = format('%02x', 256 * (2.0 - ratio))
      color = level + 'ff' + level
    end

    color
  end
end
