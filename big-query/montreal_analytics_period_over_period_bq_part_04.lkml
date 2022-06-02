### Made with Love by Montreal Analytics' team (www.montrealanalytics.com)
### Read the tutorial and more here: blog.montrealanalytics.com
### Let us know if that was helpful! (https://forms.gle/J9fE9CFauzh32VKC8)

    
############################################################################################################
################################################# BIGQUERY #################################################
############################################################################################################

### replace any reference to order_items by the explore of your choosing
### We're assuming here that the explore we we want to leverage in the PoP is order_items.

explore: +order_items {
  sql_always_where:
    1=1
    {% if order_items.current_vs_previous_period_advanced._in_query %}AND ${order_items.current_vs_previous_period_advanced} IS NOT NULL{% endif %}
    {% if parameters.apply_to_date_filter_advanced._is_filtered %}AND ${order_items.is_to_date_advanced}{% endif %}
   ;;
 
  join: parameters {}
  
}
