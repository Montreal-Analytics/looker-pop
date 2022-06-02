### Made with Love by Montreal Analytics' team (www.montrealanalytics.com)
### Read the tutorial and more here: blog.montrealanalytics.com
### Let us know if that was helpful! (https://forms.gle/J9fE9CFauzh32VKC8)

############################################################################################################
################################################# BIGQUERY #################################################
############################################################################################################

### replace any reference to order_items.created_[...] by the view/dimensions of your choosing
### We're assuming here that the date dimension we want to leverage in the PoP is order_items.created_date labeled as "Orders Date"

view: +order_items {

#####  CURRENT/REFERENCE [Timeframe] VS PREVIOUS [Timeframe] with dynamic labels and default to today

  dimension: current_vs_previous_period_advanced {
    label: "Current vs Previous Period"
    hidden: yes
    description: "Use this dimension alongside \"Select Timeframe\" and \"Select Comparison Type\" Filters to compare a specific timeframe (month, quarter, year) and the corresponding one of the previous year"
    type: string
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == "ytd" %}
        CASE
          WHEN ${order_items.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, YEAR), MONTH) AND DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, DAY)
            THEN ${selected_dynamic_timeframe_advanced}
          WHEN ${order_items.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), YEAR), MONTH) AND DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), MONTH)
            THEN ${selected_dynamic_timeframe_advanced}
          ELSE NULL
        END
      {% else %}
        {% if parameters.select_comparison._parameter_value == "year" %}
          CASE
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            ELSE NULL
          END
        {% elsif parameters.select_comparison._parameter_value == "period" %}
          CASE
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 {% parameter parameters.select_timeframe_advanced %}), {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            ELSE NULL
          END
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
        CASE
          WHEN ${order_items.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, YEAR), MONTH) AND DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, DAY)
            THEN 'reference'
          WHEN ${order_items.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), YEAR), MONTH) AND DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), MONTH)
            THEN 'comparison'
          ELSE NULL
        END
      {% else %}
        {% if parameters.select_comparison._parameter_value == "year" %}
          CASE
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN 'reference'
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), {% parameter parameters.select_timeframe_advanced %})
              THEN 'comparison'
            ELSE NULL
          END
        {% elsif parameters.select_comparison._parameter_value == "period" %}
          CASE
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN 'reference'
            WHEN DATE_TRUNC(${order_items.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 {% parameter parameters.select_timeframe_advanced %}), {% parameter parameters.select_timeframe_advanced %})
              THEN 'comparison'
            ELSE NULL
          END
        {% endif %}
      {% endif %}
    ;;
  }
}