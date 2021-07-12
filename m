Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E2D3C5B13
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 13:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhGLKzC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Jul 2021 06:55:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233422AbhGLKy7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Jul 2021 06:54:59 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CAXsmt092999;
        Mon, 12 Jul 2021 06:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=7R6IFKv6+T2NNxsIFHbeE25v9lDPCieFlU0e+MJUxKA=;
 b=XsZub7AqV6lWzVECNx+D58Cf+4LkHBs9S1NA1s+xzWPjpZebW+wGcwmYenpX4HdrQd4a
 d3kNtHYnDltRnoz01amv++P7nE/vhjihQmrjUdQJ/tx3GmAYRtHf0CmLh9/9YF5MHyXJ
 5P6s8TNVCTCG20LlXd+u2D7j6Vu7cC94XXePi1oVXHrb6/ztthmIB+J4k5N1ZZD0Pkx0
 Ux1a8RcYgzwHY7gD1tr0n38w9L5kDAZf1LIf2RwLjkl/HASgLmnKxl1//21s1zcktqaJ
 ZznmSw/PjP59Kgt5JrAUlplwHzJ631d12A1WD3pK1xT/w6j0gNj9j2QAFnfzUlXLtkI0 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrkvnutx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 06:51:49 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16CAZ0PV095882;
        Mon, 12 Jul 2021 06:51:49 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrkvnutb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 06:51:48 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16CAm2sx022672;
        Mon, 12 Jul 2021 10:51:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 39q3688qhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 10:51:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16CAphCg18940194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 10:51:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C657A4062;
        Mon, 12 Jul 2021 10:51:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C32D7A4069;
        Mon, 12 Jul 2021 10:51:41 +0000 (GMT)
Received: from pratiks-thinkpad.ibmuc.com (unknown [9.85.69.159])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Jul 2021 10:51:41 +0000 (GMT)
From:   "Pratik R. Sampat" <psampat@linux.ibm.com>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: [PATCH v3 0/1] Interface to represent PAPR firmware attributes
Date:   Mon, 12 Jul 2021 16:21:39 +0530
Message-Id: <20210712105140.33388-1-psampat@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wD84fng1mXXAMQmcmuxF743CGh0KxfZA
X-Proofpoint-ORIG-GUID: eSSSBgfKzdBE3WGwwoZawLdwUTz0hr0t
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_05:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107120082
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

RFC: https://lkml.org/lkml/2021/6/4/791
PATCH v1: https://lkml.org/lkml/2021/6/16/805
PATCH v2: https://lkml.org/lkml/2021/7/6/138

Changelog v2 --> v3
Based on a comment from Guatham:
1. Added a versioning check after the H_CALL is made to bail out when
   the version from the firmware is inconsistent with that in the kernel

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
 .../pseries/papr_platform_attributes.c        | 320 ++++++++++++++++++
 5 files changed, 372 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-papr-energy-scale-info
 create mode 100644 arch/powerpc/platforms/pseries/papr_platform_attributes.c

-- 
2.31.1

