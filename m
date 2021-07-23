Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D555D3D3442
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Jul 2021 07:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhGWFGP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 23 Jul 2021 01:06:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230421AbhGWFGN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 23 Jul 2021 01:06:13 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16N5f7QS150038;
        Fri, 23 Jul 2021 01:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=VHQjjm8DAPMfTDBzQQsDI5hUGOXPrU5yVQDztcq7e6c=;
 b=fKjhhA3Abb2m7bj91cZHPEk2F9Boi7H7zT6dw9edqq4l4r9zfFfgzhgKNDWE87EHbVfP
 R8U/zF8gqDzIBIDWtdnUKWwI/g1DGfPP8yxTe9y0cJFGVrK5WeUNDN+25+JAFJV+b5Gy
 NdEtZ8R9/dScr7uzDDM3vohBszlUo2OLN825MbrWIKWPUvFceFB2lzWEqAlGo8wVp18y
 FE8ZXAALES4evlqt8kIVW7inqHrsMaTr71XVScfTtzdNfqVJRL9GJiAqRVOhmCwPtW/U
 g++rWOHJbuRdtSATXi2pV2eM2AUadm9+DDK+kFb5yl70360TKVJl5MO3ljWzM+JBN1UE dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ynvyafum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 01:46:19 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16N5gkkp156620;
        Fri, 23 Jul 2021 01:46:18 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ynvyafua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 01:46:18 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16N5jGdb028391;
        Fri, 23 Jul 2021 05:46:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 39xhx49165-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 05:46:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16N5kDll27197746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 05:46:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F85D11C058;
        Fri, 23 Jul 2021 05:46:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05DFF11C052;
        Fri, 23 Jul 2021 05:46:11 +0000 (GMT)
Received: from pratiks-thinkpad.ibmuc.com (unknown [9.77.201.127])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 05:46:10 +0000 (GMT)
From:   "Pratik R. Sampat" <psampat@linux.ibm.com>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        farosas@linux.ibm.com, kjain@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: [PATCH v7 0/1] Interface to represent PAPR firmware attributes
Date:   Fri, 23 Jul 2021 11:16:08 +0530
Message-Id: <20210723054609.15033-1-psampat@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tpuXao94BZL5yD6gUmxYa9X3x0m4Iiy1
X-Proofpoint-GUID: 4yjttkjfY2fE2Vv0JZ-p3-waeonxY914
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_16:2021-07-22,2021-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230031
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

RFC: https://lkml.org/lkml/2021/6/4/791
PATCH v1: https://lkml.org/lkml/2021/6/16/805
PATCH v2: https://lkml.org/lkml/2021/7/6/138
PATCH v3: https://lkml.org/lkml/2021/7/12/2799
PATCH v4: https://lkml.org/lkml/2021/7/16/532
PATCH v5: https://lkml.org/lkml/2021/7/19/247
PATCH v6: https://lkml.org/lkml/2021/7/20/36

Changelog v6-->v7
1. Optimize free for pgs attributes to iterate only over the currently
   allocated attributes "idx" instead of free'ing for all

Also, have implemented a POC using this interface for the powerpc-utils'
ppc64_cpu --frequency command-line tool to utilize this information
in userspace.
The POC for the new interface has been hosted here:
https://github.com/pratiksampat/powerpc-utils/tree/H_GET_ENERGY_SCALE_INFO_v2

Sample output from the powerpc-utils tool is as follows:

# ppc64_cpu --frequency
Power and Performance Mode: XXXX
Idle Power Saver Status   : XXXX
Processor Folding Status  : XXXX --> Printed if Idle power save status is supported

Platform reported frequencies --> Frequencies reported from the platform's H_CALL i.e PAPR interface
min        :    NNNN GHz
max        :    NNNN GHz
static     :    NNNN GHz

Tool Computed frequencies
min        :    NNNN GHz (cpu XX)
max        :    NNNN GHz (cpu XX)
avg        :    NNNN GHz

Pratik R. Sampat (1):
  powerpc/pseries: Interface to represent PAPR firmware attributes

 .../sysfs-firmware-papr-energy-scale-info     |  26 ++
 arch/powerpc/include/asm/hvcall.h             |  24 +-
 arch/powerpc/kvm/trace_hv.h                   |   1 +
 arch/powerpc/platforms/pseries/Makefile       |   3 +-
 .../pseries/papr_platform_attributes.c        | 312 ++++++++++++++++++
 5 files changed, 364 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-papr-energy-scale-info
 create mode 100644 arch/powerpc/platforms/pseries/papr_platform_attributes.c

-- 
2.31.1

