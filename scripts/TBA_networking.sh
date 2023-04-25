#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# TBA_networking.sh
#
#

SCRIPT="$0"
TEST="$1"

# get External IP address
get_external_IP(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
	external_IP="$(curl ifconfig.co)"
}


get_site_ip(){
    site=$1
	{ # try
	#
        address=$(nslookup -query=a ${site} | grep 'Address:' | grep -v '8.8.8.8')
	    IFS=": "
	    read -a Arr <<< "${address}"
		site_ip=${Arr[1]}
	} || {
		echo "Could not find ${SITE} IP ${nslook}"
		unset $site_ip
	}
}

# Verify DNS record is pointed to external IP
verify_DNS_record(){
    SITE=$1
    echo -e "${IBlue}***** Function:  ${FUNCNAME} ${SITE}*****${Color_Off}"
    { # try
	echo "nslookup -query=a ${SITE}"
    nslook="$(nslookup -query=a ${SITE})"
    } || { #catch
    echo "Could not find ${SITE}  IP ${nslook}"
	nslook="***'no ip found'***"
    }

    get_external_IP

	verify_DNS=False
    if [[ "${nslook}" == *"$external_IP"* ]]; then
        echo -e "${Green}DNS setup correctly for '$SITE'${Color_Off}"
		verify_DNS=True
    else
        echo -e "${Red}DNS for ${SITE} is ${URed}NOT${Red} setup correctly"
        echo "$nslook is used for: $SITE"
        echo "External IP: $external_IP was found"
        echo "................................................"
		echo "************************************************"
	    echo "**                                            **"
        echo "** Setup DNS on google                        **"
        echo "** # update DNS on                            **"
        echo "** https://domains.google.com/registrar/      **"
        echo "**                                            **"
        echo "** Update DD-Client DNS                       **"
        echo "** # /docker/lan/ddclient/config/ddclient.conf**"
        echo "** Restart DDCLIENT                           **"
        echo "**                                            **"
        echo "** and try, try again!!!                      **"
        echo "**                                            **"
        echo "************************************************"
        echo "................................................"
		echo -e "${Color_Off}"
		build_exit 96
    fi
}

get_router_IP(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    router_IP=$(tracepath -m 1 8.8.8.8 | awk '/1:/ {print $2;exit}')
}

# get_router_IP() variable 
#  $ ip route | grep 93.68.10.42
#  default via 93.68.10.1 dev ovs_eth0  src 93.68.10.42
#  93.68.10.0/26 dev ovs_eth0  proto kernel  scope link  src 93.68.10.42
#  $ ip route | grep default
#  default via 93.68.10.1 dev ovs_eth0  src 93.68.10.42
#
#  $ ip route | grep default
# default via 93.68.10.1 dev ovs_eth0  src 93.68.10.42
#  $ ip route | grep ovs_eth0
#  default via 93.68.10.1 dev ovs_eth0  src 93.68.10.42
#  93.68.10.0/26 dev ovs_eth0  proto kernel  scope link  src 93.68.10.42
get_gateway_info(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

    gateway=$(ip route | grep "default")
#	echo ${gateway}
	# default via 93.68.10.1 dev ovs_eth0  src 93.68.10.42
	IFS=": "
	read -a Arr <<< "${gateway}"
	gateway_IP=${Arr[2]}
	gateway_card=${Arr[4]}	
	
#   subnet=$(ip route | grep ovs_eth0 | grep kernel)
	subnet=$(ip route | grep $gateway_card | grep kernel)
#	echo ${subnet}
	IFS=": "
	read -a Arr <<< "${subnet}"	
	#93.68.10.0/26 dev ovs_eth0  proto kernel  scope link  src 93.68.10.42
	gateway_subnet=${Arr[0]}
}

# "Gateway": "x.x.x.x"
get_docker_gateway(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
	local network=$1
    gateway=$(docker network inspect ${network} | grep "Gateway")

	IFS=": "
	read -a Arr <<< "$gateway"
	returnIP=${Arr[1]}
	returnIP=${returnIP//'"'/}
	returnIP=${returnIP//,/}	
}

# "Subnet": "172.19.0.0/16",
get_docker_subnet(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    local network=$1
    subnet=$(docker network inspect ${network} | grep "Subnet")
	
	IFS=": "
	read -a Arr <<< "$subnet"
	returnSubnet=${Arr[1]}
	returnSubnet=${returnSubnet//'"'/}
	returnSubnet=${returnSubnet//,/}
	
	#returnSubnet=${Arr[1]}
}

# info
display_network_info(){
    echo -e "${UBlue}***** TBA_networking.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

network_test_cases(){

	echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

	requires_root

    echo "========================================="

	echo "Get my external IP address"
	get_external_IP
    echo "External IP: $external_IP"

    echo "-----------------------------------------"
    get_router_IP
    echo "Internal Router_IP: $router_IP (internet gateway)"
    echo ""

    echo "-----------------------------------------"
	get_gateway_info
    echo "gateway_IP     : $gateway_IP"
    echo "gateway_subnet : $gateway_subnet"
    echo "gateway_card   : $gateway_card"


	COMMON_ENV=../templates/.common.env

	if [ -f "$COMMON_ENV" ]; then
		load_env COMMON_ENV
	#printenv

		echo "-----------------------------------------"
		lookup_network="macvlan-net"
		get_docker_gateway $lookup_network 
		echo "$returnIP is the gateway for $lookup_network"

		lookup_network="web"
		get_docker_gateway  $lookup_network 
		echo "$returnIP is the gateway for $lookup_network"

		lookup_network="backend"
		get_docker_gateway  $lookup_network
		echo "$returnIP is the gateway for $lookup_network"

		echo ""
		echo "-----------------------------------------"
		lookup_network="macvlan-net"
		get_docker_subnet $lookup_network
		echo "$returnSubnet is the subnet for $lookup_network"

		lookup_network="web"
		get_docker_subnet $lookup_network
		echo "$returnSubnet is the subnet for $lookup_network"

		lookup_network="backend"
		get_docker_subnet $lookup_network
		echo "$returnSubnet is the subnet for $lookup_network"


		echo ""
		echo "-----------------------------------------"
		echo "-----------------------------------------"
		
		echo "SAMPLE_DNS_SITE: ${SAMPLE_DNS_SITE}"
		verify_DNS_record ${SAMPLE_DNS_SITE}
		echo ""
		echo -e "---${Purple}"
		echo "DOCKER_PATH: $DOCKER_PATH"
		echo "TIME_ZONE: $TIME_ZONE"
		echo "DOMAIN_NAME: $DOMAIN_NAME"
		echo "ADDITIONAL_WL_SITE: $ADDITIONAL_WHITELIST_SITE"
		echo "SAMPLE_DNS_SITE: $SAMPLE_DNS_SITE"
		echo -e "---${Color_Off}"
	else
		echo -e "${Yellow}'$COMMON_ENV' not found. Need to run 'env.setup.sh'${Color_Off}"
	fi
	
    # must be last
    all_done
}

if [[ $SCRIPT =~ "TBA_networking" ]] && [ $TEST ] && [ $TEST == "test" ]; then
    clear
	INCLUDE_PATH=./
	
    . $INCLUDE_PATH/TBA_color.sh

    echo -e "${IBlue}***** ${Black}${On_White}TEST=$TEST${IBlue}, debug will run *****${Color_Off}"

	display_network_info
	
    . $INCLUDE_PATH/TBA_functions.sh

	. ../scripts/TBA_functions.sh
	
	display_network_info

	. $INCLUDE_PATH/TBA_random.sh

    echo -e "***** ${Black}${On_White}Running test_cases${Color_Off} *****"

	network_test_cases
else
	# show what we are doing
	display_network_info
fi
