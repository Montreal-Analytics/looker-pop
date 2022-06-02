### Made with Love by Montreal Analytics' team (www.montrealanalytics.com)
### Read the tutorial and more here: blog.montrealanalytics.com
### Let us know if that was helpful! (https://forms.gle/J9fE9CFauzh32VKC8)

############################################################################################################
################################################# SNOWFLAKE ################################################
############################################################################################################

### replace any reference to order_items.created_[...] by the view/dimensions of your choosing
### We're assuming here that the date dimension we want to leverage in the PoP is order_items.created_date labeled as "Orders Date"

view: +order_items {

  #####  CURRENT/REFERENCE [Timeframe] VS PREVIOUS [Timeframe]

  dimension: current_vs_previous_period_advanced {
    label: "Current vs Previous Period"
    description: "Use this dimension along with \"Select Timeframe\", \"Select Reference Date\", \"To Date\" and \"Select Comparison\" filters"
    type: string
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == "ytd" %}
        case
          when ${order_items.created_date} BETWEEN date_trunc(year, ${parameters.selected_reference_date_default_today_advanced_raw}) and ${parameters.selected_reference_date_default_today_advanced_date}
            then ${selected_dynamic_timeframe_advanced}
          when ${order_items.created_date} BETWEEN date_trunc(year, dateadd(year, -1,${parameters.selected_reference_date_default_today_advanced_raw})) and dateadd(year, -1, ${parameters.selected_reference_date_default_today_advanced_date})
            then ${selected_dynamic_timeframe_advanced}
          else null
        end
      {% else %}
        {% if parameters.select_comparison._parameter_value == "year" %}
          case
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, ${parameters.selected_reference_date_default_today_advanced_raw})
              then ${selected_dynamic_timeframe_advanced}
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, dateadd(year, -1, ${parameters.selected_reference_date_default_today_advanced_raw}))
              then ${selected_dynamic_timeframe_advanced}
          end
        {% elsif parameters.select_comparison._parameter_value == "period" %}
          case
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, ${parameters.selected_reference_date_default_today_advanced_raw})
              then ${selected_dynamic_timeframe_advanced}
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, dateadd({% parameter parameters.select_timeframe_advanced %}, -1, ${parameters.selected_reference_date_default_today_advanced_raw}))
              then ${selected_dynamic_timeframe_advanced}
          end
        {% endif %}
      {% endif %}
      ;;
  }


  dimension: current_vs_previous_period_hidden_advanced {
    label: "Current vs Previous Period (Hidden - for measure only)"
    hidden: yes
    description: "Hide this measure so that it doesn't appear in the field picket and use it to filter measures (since the values are static)"
    type: string
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == "ytd" %}
        case
          when ${order_items.created_raw} BETWEEN date_trunc(year, ${parameters.selected_reference_date_default_today_advanced_raw}) and ${parameters.selected_reference_date_default_today_advanced_raw}
            then 'reference'
          when ${order_items.created_raw} BETWEEN date_trunc(year, dateadd(year, -1, ${parameters.selected_reference_date_default_today_advanced_raw})) and dateadd(year, -1, ${parameters.selected_reference_date_default_today_advanced_date})
            then 'comparison'
          else null
        end
      {% else %}
        {% if parameters.select_comparison._parameter_value == "year" %}
          case
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, ${parameters.selected_reference_date_default_today_advanced_raw})
              then 'reference'
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, dateadd(year, -1, ${parameters.selected_reference_date_default_today_advanced_raw}))
              then 'comparison'
          end
        {% elsif parameters.select_comparison._parameter_value == "period" %}
          case
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, ${parameters.selected_reference_date_default_today_advanced_raw})
              then 'reference'
            when date_trunc({% parameter parameters.select_timeframe_advanced %}, ${order_items.created_raw}) = date_trunc({% parameter parameters.select_timeframe_advanced %}, dateadd({% parameter parameters.select_timeframe_advanced %}, -1, ${parameters.selected_reference_date_default_today_advanced_raw}))
              then 'comparison'
          end
        {% endif %}
      {% endif %}
    ;;
  }
}