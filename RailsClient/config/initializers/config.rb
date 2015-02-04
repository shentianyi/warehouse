#$SYNC_HOST = 'http://www.cz-tek.com:9000'
#$OPEN_SYN_LOCK= false
$NEED_PING= true

config=YAML.load(File.open("#{Rails.root}/config/config.yaml"))
# load format
format_config=config['format']
$CSVSP=format_config[:csv_splitor] # csv splitor
$UPMARKER=format_config[:update_marker]
$FILE_MAX_SIZE=format_config[:file_max_size]
#load path
path_config=config['path']
$UPDATAPATH=path_config[:updata_file_path]
$DOWNLOADPATH=path_config[:download_file_path]
$TEMPLATEPATH=path_config[:template_file_path]
$DELIVERYPATH=path_config[:import_delivery_file_path]
$USERPATH=path_config[:import_users_file_path]
$PARTSPATH=path_config[:import_parts_file_path]
$PARTPOSITIONSPATH=path_config[:import_part_positions_file_path]
$FORSREPROTSPATH=path_config[:fors_reports_file_path]


# api default auth user and password
auth=config['api']['auth']
$API_AUTH_USER={user: auth['user'], passwd: auth['passwd']}

#
log_config=config['log']
$LOG_FOLDER=log_config[:log_folder]
$LOG_FILE_NAME=log_config[:log_file_name]

WillPaginate.per_page = 20

PackageLabelRegex.initialize_methods if ActiveRecord::Base.connection.table_exists?('regexes')
SysConfigCache.initialize_methods if ActiveRecord::Base.connection.table_exists?('sys_configs')