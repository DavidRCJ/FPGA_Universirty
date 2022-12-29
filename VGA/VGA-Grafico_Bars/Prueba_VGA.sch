<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1(10:0)" />
        <signal name="XLXN_5(9:0)" />
        <signal name="rst" />
        <signal name="clk" />
        <signal name="XLXN_15" />
        <signal name="XLXN_16" />
        <signal name="R" />
        <signal name="G" />
        <signal name="B" />
        <signal name="VSYNC" />
        <signal name="HSYNC" />
        <signal name="XLXN_17" />
        <signal name="XLXN_18" />
        <signal name="XLXN_19" />
        <signal name="XLXN_21" />
        <signal name="XLXN_22" />
        <signal name="XLXN_26" />
        <signal name="XLXN_27" />
        <signal name="XLXN_28" />
        <signal name="XLXN_30" />
        <signal name="XLXN_31" />
        <signal name="XLXN_32(10:0)" />
        <signal name="XLXN_34(10:0)" />
        <signal name="XLXN_36" />
        <port polarity="Input" name="rst" />
        <port polarity="Input" name="clk" />
        <port polarity="Output" name="R" />
        <port polarity="Output" name="G" />
        <port polarity="Output" name="B" />
        <port polarity="Output" name="VSYNC" />
        <port polarity="Output" name="HSYNC" />
        <blockdef name="contador_horizontal">
            <timestamp>2019-6-4T23:40:32</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="generador_hsync">
            <timestamp>2019-6-4T23:40:51</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="contador_vertical">
            <timestamp>2019-6-4T23:40:39</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="generador_vsync">
            <timestamp>2019-6-4T23:41:9</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="generador_blank">
            <timestamp>2019-6-4T23:40:45</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="generador_imagen">
            <timestamp>2019-6-4T23:41:4</timestamp>
            <rect width="256" x="64" y="-320" height="320" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="DCM">
            <timestamp>2019-6-4T23:46:38</timestamp>
            <rect width="336" x="64" y="-128" height="128" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="464" y1="-96" y2="-96" x1="400" />
            <line x2="464" y1="-32" y2="-32" x1="400" />
        </blockdef>
        <block symbolname="contador_horizontal" name="XLXI_1">
            <blockpin signalname="XLXN_15" name="clk50MHz" />
            <blockpin signalname="rst" name="reset" />
            <blockpin signalname="XLXN_1(10:0)" name="h_cuenta(10:0)" />
        </block>
        <block symbolname="generador_hsync" name="XLXI_2">
            <blockpin signalname="XLXN_15" name="clk50MHz" />
            <blockpin signalname="rst" name="reset" />
            <blockpin signalname="XLXN_1(10:0)" name="h_cuenta(10:0)" />
            <blockpin signalname="HSYNC" name="hsync" />
        </block>
        <block symbolname="contador_vertical" name="XLXI_3">
            <blockpin signalname="HSYNC" name="hsync" />
            <blockpin signalname="XLXN_15" name="clk50MHz" />
            <blockpin signalname="rst" name="reset" />
            <blockpin signalname="XLXN_5(9:0)" name="v_cuenta(9:0)" />
        </block>
        <block symbolname="generador_vsync" name="XLXI_4">
            <blockpin signalname="XLXN_15" name="clk50MHz" />
            <blockpin signalname="rst" name="reset" />
            <blockpin signalname="XLXN_5(9:0)" name="v_cuenta(9:0)" />
            <blockpin signalname="VSYNC" name="vsync" />
        </block>
        <block symbolname="generador_blank" name="XLXI_5">
            <blockpin signalname="XLXN_1(10:0)" name="hctr(10:0)" />
            <blockpin signalname="XLXN_5(9:0)" name="vctr(9:0)" />
            <blockpin signalname="XLXN_16" name="blank" />
        </block>
        <block symbolname="generador_imagen" name="XLXI_6">
            <blockpin signalname="XLXN_16" name="blank" />
            <blockpin signalname="XLXN_15" name="clk50MHz" />
            <blockpin signalname="rst" name="reset" />
            <blockpin signalname="XLXN_1(10:0)" name="hctr(10:0)" />
            <blockpin signalname="XLXN_5(9:0)" name="vctr(9:0)" />
            <blockpin signalname="R" name="R" />
            <blockpin signalname="G" name="G" />
            <blockpin signalname="B" name="B" />
        </block>
        <block symbolname="DCM" name="XLXI_7">
            <blockpin signalname="rst" name="RST_IN" />
            <blockpin signalname="clk" name="CLKIN_IN" />
            <blockpin name="CLKIN_IBUFG_OUT" />
            <blockpin signalname="XLXN_15" name="CLK0_OUT" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1744" y="592" name="XLXI_3" orien="R0">
        </instance>
        <branch name="rst">
            <wire x2="432" y1="864" y2="864" x1="400" />
        </branch>
        <branch name="clk">
            <wire x2="432" y1="928" y2="928" x1="400" />
        </branch>
        <branch name="rst">
            <wire x2="640" y1="624" y2="624" x1="400" />
            <wire x2="688" y1="624" y2="624" x1="640" />
            <wire x2="1136" y1="496" y2="496" x1="640" />
            <wire x2="1216" y1="496" y2="496" x1="1136" />
            <wire x2="640" y1="496" y2="624" x1="640" />
            <wire x2="1616" y1="336" y2="336" x1="1136" />
            <wire x2="2480" y1="336" y2="336" x1="1616" />
            <wire x2="1616" y1="336" y2="560" x1="1616" />
            <wire x2="1744" y1="560" y2="560" x1="1616" />
            <wire x2="1616" y1="560" y2="1136" x1="1616" />
            <wire x2="2464" y1="1136" y2="1136" x1="1616" />
            <wire x2="1136" y1="336" y2="496" x1="1136" />
        </branch>
        <iomarker fontsize="28" x="400" y="624" name="rst" orien="R180" />
        <branch name="R">
            <wire x2="2928" y1="1008" y2="1008" x1="2848" />
            <wire x2="2928" y1="1008" y2="1056" x1="2928" />
            <wire x2="2944" y1="1056" y2="1056" x1="2928" />
        </branch>
        <iomarker fontsize="28" x="2944" y="1056" name="R" orien="R0" />
        <branch name="G">
            <wire x2="2928" y1="1136" y2="1136" x1="2848" />
            <wire x2="2928" y1="1136" y2="1184" x1="2928" />
            <wire x2="2944" y1="1184" y2="1184" x1="2928" />
        </branch>
        <iomarker fontsize="28" x="2944" y="1184" name="G" orien="R0" />
        <branch name="B">
            <wire x2="2928" y1="1264" y2="1264" x1="2848" />
            <wire x2="2928" y1="1264" y2="1312" x1="2928" />
            <wire x2="2944" y1="1312" y2="1312" x1="2928" />
        </branch>
        <iomarker fontsize="28" x="2944" y="1312" name="B" orien="R0" />
        <branch name="VSYNC">
            <wire x2="2928" y1="272" y2="272" x1="2864" />
        </branch>
        <branch name="HSYNC">
            <wire x2="1696" y1="432" y2="432" x1="1600" />
            <wire x2="1744" y1="432" y2="432" x1="1696" />
            <wire x2="2960" y1="128" y2="128" x1="1696" />
            <wire x2="1696" y1="128" y2="432" x1="1696" />
        </branch>
        <instance x="432" y="960" name="XLXI_7" orien="R0">
        </instance>
        <iomarker fontsize="28" x="400" y="864" name="rst" orien="R180" />
        <iomarker fontsize="28" x="400" y="928" name="clk" orien="R180" />
        <instance x="1216" y="592" name="XLXI_2" orien="R0">
        </instance>
        <instance x="2480" y="432" name="XLXI_4" orien="R0">
        </instance>
        <branch name="XLXN_15">
            <wire x2="1216" y1="432" y2="432" x1="544" />
            <wire x2="544" y1="432" y2="560" x1="544" />
            <wire x2="688" y1="560" y2="560" x1="544" />
            <wire x2="544" y1="560" y2="704" x1="544" />
            <wire x2="960" y1="704" y2="704" x1="544" />
            <wire x2="960" y1="704" y2="928" x1="960" />
            <wire x2="960" y1="928" y2="1072" x1="960" />
            <wire x2="1728" y1="1072" y2="1072" x1="960" />
            <wire x2="2208" y1="1072" y2="1072" x1="1728" />
            <wire x2="2464" y1="1072" y2="1072" x1="2208" />
            <wire x2="960" y1="928" y2="928" x1="896" />
            <wire x2="1744" y1="496" y2="496" x1="1728" />
            <wire x2="1728" y1="496" y2="1072" x1="1728" />
            <wire x2="2480" y1="272" y2="272" x1="2208" />
            <wire x2="2208" y1="272" y2="1072" x1="2208" />
        </branch>
        <iomarker fontsize="28" x="2960" y="128" name="HSYNC" orien="R0" />
        <iomarker fontsize="28" x="2928" y="272" name="VSYNC" orien="R0" />
        <instance x="688" y="656" name="XLXI_1" orien="R0">
        </instance>
        <instance x="2528" y="752" name="XLXI_5" orien="R0">
        </instance>
        <instance x="2464" y="1296" name="XLXI_6" orien="R0">
        </instance>
        <branch name="XLXN_16">
            <wire x2="2928" y1="832" y2="832" x1="2400" />
            <wire x2="2400" y1="832" y2="1008" x1="2400" />
            <wire x2="2464" y1="1008" y2="1008" x1="2400" />
            <wire x2="2928" y1="656" y2="656" x1="2912" />
            <wire x2="2928" y1="656" y2="832" x1="2928" />
        </branch>
        <branch name="XLXN_1(10:0)">
            <wire x2="1120" y1="560" y2="560" x1="1072" />
            <wire x2="1216" y1="560" y2="560" x1="1120" />
            <wire x2="1120" y1="560" y2="656" x1="1120" />
            <wire x2="1248" y1="656" y2="656" x1="1120" />
            <wire x2="2528" y1="656" y2="656" x1="1248" />
            <wire x2="1248" y1="656" y2="1200" x1="1248" />
            <wire x2="2464" y1="1200" y2="1200" x1="1248" />
        </branch>
        <branch name="XLXN_5(9:0)">
            <wire x2="2320" y1="432" y2="432" x1="2128" />
            <wire x2="2320" y1="432" y2="720" x1="2320" />
            <wire x2="2528" y1="720" y2="720" x1="2320" />
            <wire x2="2320" y1="720" y2="1264" x1="2320" />
            <wire x2="2464" y1="1264" y2="1264" x1="2320" />
            <wire x2="2320" y1="400" y2="432" x1="2320" />
            <wire x2="2480" y1="400" y2="400" x1="2320" />
        </branch>
    </sheet>
</drawing>