#!/bin/bash 
if [ -e output.html ]
then rm -f output.html
fi
######################## html header ########################
echo ' 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style>
<style>
.title_0 {
  background-color:#95B9C7;
  font: 20px bold;
}
.title_1 {
  font: 20px bold;
}
.err {
  background-color:red;
}
.fail {
  background-color: yellow;
}
body{
  font-size: 17px;
}</style>' >> output.html

########################### Prepare source ############################



#mkdir -p openh264_testCoverage_API

#cd ./openh264_testCoverage_API


#rm -rf openh264


#git clone https://github.com/cisco/openh264.git
#cd openh264
#make gtest-bootstrap

########################### API ############################

vFolder="./openh264_testCoverage_API/openh264"
cd ${vFolder}
vCoverFile="./code-coverage/index.html"
#### Store the previous coverage data
vPrevNum=(`sed -n '/<td class="headerCovTableEntry">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vPrevRatio=(`sed -n '/<td class="headerCovTableEntryMed">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'` `sed -n '/<td class="headerCovTableEntryLo">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vPrevDate=`sed -n '/<td class="headerValue">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`
vPrevDate=`echo $vPrevDate | awk '{print $2}'`

#### Clean and update

./auto_clean_update.sh

#### Need modified when Makefile changes 
#### NOTE: changes when return to master branch
sed -i '/test\/decoder\/targets.mk/d' Makefile
sed -i '/test\/encoder\/targets.mk/d' Makefile
sed -i '/test\/processing\/targets.mk/d' Makefile
sed -i '/test\/common\/targets.mk/d' Makefile

make BUILDTYPE=Release USE_ASM=No  GCOV=Yes

./codec_unittest
#./auto_run_decoder.sh
#./auto_run_encoder.sh

./code-coverage.sh

#Store the current data file
cd ../..
vCoverFile="${vFolder}/code-coverage/index.html"
vCurrNum=(`sed -n '/<td class="headerCovTableEntry">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vCurrRatio=(`sed -n '/<td class="headerCovTableEntryMed">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'` `sed -n '/<td class="headerCovTableEntryLo">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vCurrDate=`sed -n '/<td class="headerValue">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`
vCurrDate=`echo $vCurrDate | awk '{print $2}'`

echo "<br><font class="title_0">Openh264 code coverage of API test</font>" >> output.html
echo "<br><font class="title_1">Test date: ${vCurrDate}</font>" >> output.html
cat >> output.html << EOF
<br>
   <table  style="width:600px" cellspacing="0" border="1" width="100%">
      <thead style="text-align:center; font-weight: bold;">
        <tr>
          <td>Category</td>
          <td>Hit</td>
          <td>Total</td>
          <td>Coverage</td>
        </tr>
      </thead>
     
      <tbody >
          <tr style="text-align:center; ">
            <td>Lines</td>
            <td>${vCurrNum[0]}</td>
            <td>${vCurrNum[1]}</td>
            <td><font class="fail">${vCurrRatio[0]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Functions</td>
            <td>${vCurrNum[2]}</td>
            <td>${vCurrNum[3]}</td>
            <td><font class="fail">${vCurrRatio[2]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Branchs</td>
            <td>${vCurrNum[4]}</td>
            <td>${vCurrNum[5]}</td>
            <td><font class="fail">${vCurrRatio[4]}%</font></td>
          </tr>
      </tbody>
    </table>
<br>
EOF

echo "<br><font class="title_1">Test date: ${vPrevDate}</font>" >> output.html
cat >> output.html << EOF
<br>
   <table  style="width:600px" cellspacing="0" border="1" width="100%">
      <thead style="text-align:center; font-weight: bold;">
        <tr>
          <td>Category</td>
          <td>Hit</td>
          <td>Total</td>
          <td>Coverage</td>
        </tr>
      </thead>
     
      <tbody >
          <tr style="text-align:center; ">
            <td>Lines</td>
            <td>${vPrevNum[0]}</td>
            <td>${vPrevNum[1]}</td>
            <td><font class="fail">${vPrevRatio[0]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Functions</td>
            <td>${vPrevNum[2]}</td>
            <td>${vPrevNum[3]}</td>
            <td><font class="fail">${vPrevRatio[2]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Branchs</td>
            <td>${vPrevNum[4]}</td>
            <td>${vPrevNum[5]}</td>
            <td><font class="fail">${vPrevRatio[4]}%</font></td>
          </tr>
      </tbody>
    </table>
<br>
EOF

vPrevLineRatio=${vPrevRatio[0]}"%"
vCurrLineRatio=${vCurrRatio[0]}"%"

########################### Prepare source ############################
#mkdir -p openh264_testCoverage_UT
#cd ./openh264_testCoverage_UT
#rm -rf openh264
#git clone https://github.com/cisco/openh264.git
#cd openh264
#make gtest-bootstrap
############################ UT ##############################
vFolder="./openh264_testCoverage_UT/openh264"
cd ${vFolder}
vCoverFile="./code-coverage/index.html"

#### Store the previous coverage data
vPrevNum=(`sed -n '/<td class="headerCovTableEntry">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vPrevRatio=(`sed -n '/<td class="headerCovTableEntryMed">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'` `sed -n '/<td class="headerCovTableEntryLo">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vPrevDate=`sed -n '/<td class="headerValue">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`
vPrevDate=`echo $vPrevDate | awk '{print $2}'`

#### Clean and update

./auto_clean_update.sh

#### Need modified when Makefile changes 
#### NOTE: changes when return to master branch
sed -i '/\/BaseDecoderTest.cpp/d' ./test/api/targets.mk
sed -i '/\/BaseEncoderTest.cpp/d' ./test/api/targets.mk
sed -i '/\/cpp_interface_test.cpp/d' ./test/api/targets.mk
sed -i '/\/decode_encode_test.cpp/d' ./test/api/targets.mk
sed -i '/\/encode_decode_api_test.cpp/d' ./test/api/targets.mk
sed -i '/\/decoder_test.cpp/d' ./test/api/targets.mk
sed -i '/\/encoder_test.cpp/d' ./test/api/targets.mk

sed -i '/\/EncUT_EncoderExt.cpp/d' ./test/encoder/targets.mk
sed -i '/\/EncUT_InterfaceTest.cpp/d' ./test/encoder/targets.mk

make BUILDTYPE=Release USE_ASM=No  GCOV=Yes

./codec_unittest

./code-coverage.sh

#Store the current data file
cd ../..
vCoverFile="${vFolder}/code-coverage/index.html"
vCurrNum=(`sed -n '/<td class="headerCovTableEntry">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vCurrRatio=(`sed -n '/<td class="headerCovTableEntryMed">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'` `sed -n '/<td class="headerCovTableEntryLo">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`)
vCurrDate=`sed -n '/<td class="headerValue">/p' ${vCoverFile} | awk -F ">|<" '{print $3}'`
vCurrDate=`echo $vCurrDate | awk '{print $2}'`

echo "<br><font class="title_0">Openh264 code coverage of func level test</font>" >> output.html
echo "<br><font class="title_1">Test date: ${vCurrDate}</font>" >> output.html
cat >> output.html << EOF
<br>
   <table  style="width:600px" cellspacing="0" border="1" width="100%">
      <thead style="text-align:center; font-weight: bold;">
        <tr>
          <td>Category</td>
          <td>Hit</td>
          <td>Total</td>
          <td>Coverage</td>
        </tr>
      </thead>
     
      <tbody >
          <tr style="text-align:center; ">
            <td>Lines</td>
            <td>${vCurrNum[0]}</td>
            <td>${vCurrNum[1]}</td>
            <td><font class="fail">${vCurrRatio[0]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Functions</td>
            <td>${vCurrNum[2]}</td>
            <td>${vCurrNum[3]}</td>
            <td><font class="fail">${vCurrRatio[2]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Branchs</td>
            <td>${vCurrNum[4]}</td>
            <td>${vCurrNum[5]}</td>
            <td><font class="fail">${vCurrRatio[4]}%</font></td>
          </tr>
      </tbody>
    </table>
<br>
EOF

echo "<br><font class="title_1">Test date: ${vPrevDate}</font>" >> output.html
cat >> output.html << EOF
<br>
   <table  style="width:600px" cellspacing="0" border="1" width="100%">
      <thead style="text-align:center; font-weight: bold;">
        <tr>
          <td>Category</td>
          <td>Hit</td>
          <td>Total</td>
          <td>Coverage</td>
        </tr>
      </thead>
     
      <tbody >
          <tr style="text-align:center; ">
            <td>Lines</td>
            <td>${vPrevNum[0]}</td>
            <td>${vPrevNum[1]}</td>
            <td><font class="fail">${vPrevRatio[0]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Functions</td>
            <td>${vPrevNum[2]}</td>
            <td>${vPrevNum[3]}</td>
            <td><font class="fail">${vPrevRatio[2]}%</font></td>
          </tr>
      </tbody>

      <tbody>
          <tr style="text-align:center; ">
            <td>Branchs</td>
            <td>${vPrevNum[4]}</td>
            <td>${vPrevNum[5]}</td>
            <td><font class="fail">${vPrevRatio[4]}%</font></td>
          </tr>
      </tbody>
    </table>
<br>
EOF

########################## Mail ##########################

#vSubject="openh264 - Code Coverage - Today:("${vCurrLineRatio},${vCurrRatio[0]}"%) - Yesterday:(""${vPrevLineRatio},${vPrevRatio[0]}""%)"
#mutt -e "set content_type=text/html" wme-all@cisco.com -s "${vSubject}" < output.html

#rm -f output.html
#rm -f sent
