#!/bin/bash

################## 2/6/14 #########################
# Script by Evan Lutkenhoff, lutkenhoff@ucla.edu  #
# Monti Lab (http://montilab.psych.ucla.edu)      #
# Tools used within script are copyrighted by:    #   
# FSL (http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSL) #
# & AFNI (http://afni.nimh.nih.gov/afni/)         #
###################################################

####usage notes/comments####
howtouse() {
echo ""
echo "How To Use:   sh optiBET.sh -i <input_image> -options"
echo ""
echo "* if option is -f script uses FSL for initial extraction (default)"
echo "* if option is -a script uses AFNI for initial extraction"
echo "* if option is -o script uses MNI152_T1_1mm_brain_mask.nii for mask (default)"
echo "* if option is -t script uses MNI152_T1_2mm_brain_mask.nii for mask"
echo "* if option is -g script uses avg152T1_brain.nii for mask"
echo "* if option is -d use debug mode (will NOT delete intermediate files)"
echo "* script requires proper installation of FSL and AFNI"
echo "* input image should be in standard orientation"
echo "* use .nii image for input"
echo "* outputs binarized brain-extraction mask, saved as:  <input_image>_optiBET_brain_mask.nii"
echo "* and full-intensity brain-extraction, saved as: <input_image>_optiBET_brain.nii"
echo ""
exit 1
}
[ "$1" = "" ] && howtouse

####setup environment variables####
#setup environment variable for AFNI
#afnidirtemp=`which 3dSkullStrip`
#afnidir=`echo $afnidirtemp | awk -F "3dSkullStrip" '{print $1}'`
#setup environment variables for FSL
#FSLDIR already stored if installed


####PARSE options########################
#sets up initial values for brain extraction and MNI mask and debug
s1=bet; #default step1
mask=MNI152_T1_1mm_brain_mask.nii; #default MNI mask
debugger=no; #default delete intermediate files
FSLOUTPUTTYPE=NIFTI
export FSLOUTPUTTYPE

while getopts i:faotgd name
do
case $name in
i)iopt=$OPTARG;;
f)fopt=1;;
a)aopt=1;;
o)oopt=1;;
t)topt=1;;
g)gopt=1;;
d)dopt=1;;
*)echo "Invalid option as argument"; exit 1;; #exits if bad option used
esac
done

if [[ ! -z $iopt ]]
then
i=`${FSLDIR}/bin/remove_ext $iopt`; #removes file extensions from input image
echo $i "is input image"
fi
if [[ ! -z $fopt ]]
then
s1=bet; #use FSL
fi
if [[ ! -z $aopt ]]
then
s1=3dSS; #use AFNI
fi
if [[ ! -z $oopt ]]
then
mask=MNI152_T1_1mm_brain_mask.nii; #use 1mm mask
fi
if [[ ! -z $topt ]]
then
mask=MNI152_T1_2mm_brain_mask.nii; #use 2mm mask
fi
if [[ ! -z $gopt ]]
then
mask=avg152T1_brain.nii; #use avg mask
fi
if [[ ! -z $dopt ]]
then
debugger=no; #keeps intermediate files
echo "debug: do NOT delete intermediate files"
fi
#following takes care of inputting conflicting options
if [[ ! -z $fopt ]] && [[ ! -z $aopt ]]; then
echo "only specify one option for inital extraction (-f OR -a)"
exit 1
fi
if [[ ! -z $oopt ]] && [[ ! -z $topt ]] && [[ ! -z $gopt ]]; then
echo "only specify one option for mask (-o, -t, or -g)"
exit 1
fi
if [[ ! -z $oopt ]] && [[ ! -z $topt ]]; then
echo "only specify one option for mask (-o, -t, or -g)"
exit 1
fi
if [[ ! -z $oopt ]] && [[ ! -z $gopt ]]; then
echo "only specify one option for mask (-o, -t, or -g)"
exit 1
fi
if [[ ! -z $topt ]] && [[ ! -z $gopt ]]; then
echo "only specify one option for mask (-o, -t, or -g)"
exit 1
fi

shift $(($OPTIND -1))
echo "for subject $iopt use $s1 for step 1 and $mask for MNI mask"
####END PARSE #################################


#### step 1 initial brain extraction ####
if [[ "$s1" == "bet" ]]; then
    echo step1 BET -B -f 0.1 subject ${i} for initial extraction
    bet ${iopt} ${i}_step1 -B -f 0.1
else
    echo step1 AFNI 3dSkullStrip subject ${i} for initial extraction
$afnidir/3dSkullStrip -input ${iopt} -prefix ${i}_step1.nii &>/dev/null #suppress screen output b/c a lot
fi

#### step 2 linear transform to MNI space #######
echo step2 flirt subject ${i} to MNI space
flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -in ${i}_step1.nii -omat ${i}_step2.mat -out ${i}_step2 -searchrx -30 30 -searchry -30 30 -searchrz -30 30

#### step 3 nonlinear transform to MNI space #######
echo step3 fnirt subject ${i} to MNI space
fnirt --in=${i} --aff=${i}_step2.mat --cout=${i}_step3 --config=T1_2_MNI152_2mm

#### step 4 is a test to see if fnirt worked correctly #######
#step 4 applywarp to put subject in MNI space using step3 as input
echo step4 applywarp to put subject ${i} in MNI space
applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${i} --warp=${i}_step3 --out=${i}_step4

#### step 5 invert nonlinear warp #######
#step 5 invert nonlinear warp to be used later in step 6 to apply to various brain masks (b/c already in MNI space) to put into each subjects space
echo step5 invert nonlinear warp for subject ${i}
invwarp -w ${i}_step3.nii -o ${i}_step5.nii -r ${i}_step1.nii

#### step 6 apply inverted nonlinear warp to labels #######
#step 6 apply inverted nonlinear warp to put label subject space
echo step6 apply inverted nonlinear warp to MNI label: MNI152_T1_1mm_brain_mask for subject ${i}
applywarp --ref=${i} --in=${FSLDIR}/data/standard/${mask} --warp=${i}_step5.nii --out=${i}_step6 --interp=nn

#### step 7 binarize brain extractions #######
echo creating binary brain mask for subject ${i}
fslmaths ${i}_step6.nii -bin ${i}_brain_mask

#### step 8 punch out mask from brain to do skull-stripping #######
echo creating brain extraction for subject ${i}
fslmaths ${i} -mas ${i}_brain_mask ${i}_brain

###debug or not #####
if [ "$debugger" == "yes" ];then
echo "keep intermediate files"
else
echo "removing intermediate files"
rm ${i}_step1.nii ${i}_step1_mask.nii ${i}_step2.nii ${i}_step2.mat ${i}_step3.nii ${i}_step4.nii ${i}_step5.nii ${i}_step6.nii
fi
