#!/bin/bash
# pick-card.sh

# This is an example of choosing random elements of an array.


# Pick a card, any card.

modules="acquia_connector
admin_menu
admin_views
advanced_help
apachesolr
apachesolr_file
apachesolr_realtime
apachesolr_views
apps
autosave
backports
better_exposed_filters
better_formats
biblio
biblio_search_api
biblio_zotero
blazemeter
book_made_simple
breakpoints
bundle_copy
caption_filter
chosen
ckeditor
ckeditor_link
computed_field
context
cors
creative_commons
cron_debug
css_injector
ctools
data_export_import
datatables
date
date_popup_authored
defaultconfig
delete_all
devel
diff
ds
entity
entity_view_mode
entityreference
entityreference_prepopulate
facetapi
facetapi_bonus
facetapi_slider
fape
features
features_diff
feeds
field_collection
field_group
field_permissions
fieldable_panels_panes
file_entity
filefield_sources
fivestar
flag
gdoc_field
genpass
geofield
geophp
globalredirect
i18n
i18nviews
image_resize_filter
job_scheduler
jquery_update
js_injector
json2
kaltura
libraries
lightbox2
link
linkit
masquerade
mass_contact
mathjax
mb
media
media_ckeditor
media_vimeo
media_youtube
menu_block
menu_target
message
message_notify
module_filter
nice_menus
node_export
og
og_access_roles
og_subgroups
page_manager_templates
page_title
pagerer
panelizer
panels
panels_bootstrap_layouts
panels_breadcrumbs
panels_php
password_policy
pathauto
pathologic
permissions_export
pm_existing_pages
publishcontent
purl
quicktabs
realname
redirect
references
rules
save_draft
search_api
search_api_autocomplete
search_api_db
search_api_grouping
search_api_override
search_api_ranges
search_api_solr
search_api_views_empty_query
seckit
securepages
services
services_views
sharethis
simple_gmap
simplified_menu_admin
strongarm
tablefield
taxonomy_block
term_reference_tree
token
translation_helpers
user_picture_field
username_enumeration_prevention
uuid
variable
views
views_autocomplete_filters
views_bootstrap
views_bulk_operations
views_data_export
views_litepager
views_php
views_slideshow
views_sort_null_field
views_tree
votingapi
watchdog_array
webform
webform_conditional
webform_report
wysiwyg
wysiwyg_filter
xmlsitemap"


# Note variables spread over multiple lines.


mods_array=($modules)                # Read into array variable.
#denomination=($Denominations)

num_mods=${#mods_array[*]}        # Count how many elements.
#num_denominations=${#denomination[*]}

echo "${mods_array[$((RANDOM%num_mods))]}"
#echo ${suite[$((RANDOM%num_suites))]}


# $bozo sh pick-cards.sh
# Jack of Clubs


# Thank you, "jipe," for pointing out this use of $RANDOM.
exit 0
