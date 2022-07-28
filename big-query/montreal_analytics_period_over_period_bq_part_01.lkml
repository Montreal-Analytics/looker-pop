### Made with Love by Montreal Analytics' team (www.montrealanalytics.com)
### Read the tutorial and more here: blog.montrealanalytics.com
### Let us know if that was helpful! (https://forms.gle/J9fE9CFauzh32VKC8)

view: parameters {

  parameter: select_timeframe_advanced {
    label: "Select Timeframe"
    type: unquoted
    default_value: "month"
    allowed_value: {
      value: "year"
      label: "Years"
    }
    allowed_value: {
      value: "quarter"
      label: "Quarters"
    }
    allowed_value: {
      value: "month"
      label: "Months"
    }
    allowed_value: {
      value: "week"
      label: "Weeks"
    }
    allowed_value: {
      value: "day"
      label: "Days"
    }
    allowed_value: {
    value: "ytd"
    label: "YTD"
    }
  }

  parameter: select_comparison  {
    label: "Select Comparison Type"
    group_label: ""
    group_item_label: ""

    type: unquoted
    default_value: "period"

    allowed_value: {
      label: "Previous Year"
      value: "year"
    }

    allowed_value: {
      label: "Previous Period"
      value: "period"
    }
  }

  parameter: apply_to_date_filter_advanced {
    type: yesno
    default_value: "false"
  }

  parameter: select_reference_date_advanced {
    label: " Select Reference Date"
    description: "Choose any date to compare it with the previous day/week/month/year. Any date during a week/month/year will act as the entire week/month/year"
    type: date
    convert_tz: no
  }


### CURRENT TIMESTAMP {

  dimension_group: current_timestamp_advanced {
    type: time
    hidden: yes
    timeframes: [raw,hour,date,week,month,month_name,month_num,year,hour_of_day,day_of_week_index,day_of_month,day_of_year]
    sql: CURRENT_TIMESTAMP() ;;

  }


  dimension: current_timestamp_month_of_quarter_advanced {
    type: number
    hidden: yes
    sql:
      CASE
        WHEN ${current_timestamp_advanced_month_num} IN (1,4,7,10) THEN 1
        WHEN ${current_timestamp_advanced_month_num} IN (2,5,8,11) THEN 2
        ELSE 3
      END
    ;;
  }

  dimension_group: selected_reference_date_default_today_advanced { 
    description: "This Dimension will make sure that when \"Select Reference date\" is set in  the future then we use the current day for reference"
    hidden: yes
    type: time
    convert_tz: no
    datatype: date
    timeframes: [raw,date,day_of_month,day_of_week,day_of_week_index,day_of_year,week, week_of_year, month, month_name, month_num, quarter, quarter_of_year, year]
    sql:
      case
        when {% parameter parameters.select_reference_date_advanced %} is null or ${parameters.current_timestamp_advanced_date} <= date({% parameter parameters.select_reference_date_advanced %})
          then ${parameters.current_timestamp_advanced_date}
        else date({% parameter parameters.select_reference_date_advanced %})
      end
    ;;
  }

### CURRENT TIMESTAMP }
}
