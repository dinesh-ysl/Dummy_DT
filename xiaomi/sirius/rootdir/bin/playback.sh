# $1: wave file to read
# $2: device for output
#     0: current
#     1: speaker
#     2: receiver
#     3: headphone

# tinyplay file.wav [-D card] [-d device] [-p period_size] [-n n_periods]
# sample usage: playback.sh 2000.wav  1

function enable_receiver
{
	echo "enabling receiver"
    tinymix 'INT0_MI2S_RX Audio Mixer MultiMedia1' 1
    tinymix 'RX1 MIX1 INP1' 'RX1'
    tinymix 'RDAC2 MUX' 'RX1'
    tinymix 'EAR_S' 'Switch'
}

function disable_receiver
{
	echo "disabling receiver"
    tinymix 'RX1 MIX1 INP1' 'ZERO'
    tinymix 'RDAC2 MUX' 'ZERO'
    tinymix 'EAR_S' 'ZERO'
    tinymix 'INT0_MI2S_RX Audio Mixer MultiMedia1' 0
}

function enable_speaker
{
    echo "enabling speaker"
    tinymix 'PRI_MI2S_RX Audio Mixer MultiMedia1' 1
    tinymix 'Program' 1
    sleep 1
}

function disable_speaker
{
    echo "disabling speaker"
    tinymix 'PRI_MI2S_RX Audio Mixer MultiMedia1' 0
    tinymix 'Program' 0
}

function enable_headphone
{
	echo "enabling headphone"
	tinymix 'INT0_MI2S_RX Audio Mixer MultiMedia1' 1
	tinymix 'INT0_MI2S_RX Channels' 'Two'
	tinymix 'RX1 MIX1 INP1' 'RX1'
	tinymix 'RX2 MIX1 INP1' 'RX2'
	tinymix 'RDAC2 MUX' 'RX2'
	tinymix 'RX HPH Mode' 'HD2'
	tinymix 'HPHL' 'Switch'
	tinymix 'HPHR' 'Switch'
}

function disable_headphone
{
	echo "disabling headphone"
	tinymix 'INT0_MI2S_RX Channels' 'One'
	tinymix 'RX1 MIX1 INP1' 'ZERO'
	tinymix 'RX2 MIX1 INP1' 'ZERO'
	tinymix 'RDAC2 MUX' 'ZERO'
	tinymix 'HPHL' 'ZERO'
	tinymix 'HPHR' 'ZERO'
	tinymix 'RX HPH Mode' 'ZERO'
	tinymix 'INT0_MI2S_RX Audio Mixer MultiMedia1' 0
}

if [ "$2" -eq "1" ]; then
	enable_speaker
elif [ "$2" -eq "2" ]; then
	enable_receiver
elif [ "$2" -eq "3" ]; then
	enable_headphone
fi

echo "start playing"
tinyplay $1

if [ "$2" -eq "1" ]; then
	disable_speaker
elif [ "$2" -eq "2" ]; then
	disable_receiver
elif [ "$2" -eq "3" ]; then
	disable_headphone
fi

exit 0
