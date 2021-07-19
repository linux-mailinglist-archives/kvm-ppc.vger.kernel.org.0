Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169183CD0F5
	for <lists+kvm-ppc@lfdr.de>; Mon, 19 Jul 2021 11:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhGSIwo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 19 Jul 2021 04:52:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236034AbhGSIwl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 19 Jul 2021 04:52:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J98NqC049137;
        Mon, 19 Jul 2021 05:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=qkVILrVrkezAlf6uEY13G0NBpgbAq5yXA5UCFY0v4F8=;
 b=XDMXSQPadiDQ7oYweCTlM9XRsH5YaXFcXm7kCnYeFEkwTESmJYo+j/ION6GFGk+wM9IN
 aZtvnSibGtyfTFH6oscH+6DSpdjIXhg0ABRhQZU3feal5wdl6xb0ePwU74Znn0smGL18
 FZJqkvxhFxUprvL3skSrr1yAWjRpiuS8dvDOOX4SkOs2/RkOM3I94medeDDxsc5CH4VL
 A+zOvK9ZX710xQ6ng6ggUE0MwBIayeVLOBqJx17UYJT+IIHejtMo18sr8kD1HFuDCwoE
 ptBMiXjbh/3JMMUwHP7YczoqqFxUoumVYfPdBoWk2xWPFRnnN7Mvgro3t+sBSHZHMAKt cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39w46hmk49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 05:32:58 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16J98U4d049925;
        Mon, 19 Jul 2021 05:32:58 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39w46hmk3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 05:32:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16J9WiNO005206;
        Mon, 19 Jul 2021 09:32:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 39upu88mqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 09:32:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16J9Wrw432768424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 09:32:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86B7AA4054;
        Mon, 19 Jul 2021 09:32:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D29DA4065;
        Mon, 19 Jul 2021 09:32:51 +0000 (GMT)
Received: from pratiks-thinkpad.ibmuc.com (unknown [9.85.84.3])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jul 2021 09:32:51 +0000 (GMT)
From:   "Pratik R. Sampat" <psampat@linux.ibm.com>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: [PATCH v5 0/1] Interface to represent PAPR firmware attributes
Date:   Mon, 19 Jul 2021 15:02:49 +0530
Message-Id: <20210719093250.41405-1-psampat@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D8BPBzrnw6bdQVe4A0NyaaTTxsHvEIja
X-Proofpoint-GUID: 6XSXm428OlZ6J4YW9x5e1oWRMwtn9nBY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_02:2021-07-16,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190050
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

RFC: https://lkml.org/lkml/2021/6/4/791
PATCH v1: https://lkml.org/lkml/2021/6/16/805
PATCH v2: https://lkml.org/lkml/2021/7/6/138
PATCH v3: https://lkml.org/lkml/2021/7/12/2799
PATCH v4: https://lkml.org/lkml/2021/7/16/532

Changelog v4 --> v5
Based on comments from Fabiano
1. Cleaned up unused/redundant headers
2. Make "add_attr_group" use MAX_ATTRS instead of paramterizing "len"
3. Cleanup previous "pgs[idx].pg.attrs" allocations on failiure
4. Replaced strlen call with strnlen
5. Cleanup of pgs structures for "num_attrs" instead of "MAX_ATTRS"

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
 .../pseries/papr_platform_attributes.c        | 317 ++++++++++++++++++
 5 files changed, 369 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-papr-energy-scale-info
 create mode 100644 arch/powerpc/platforms/pseries/papr_platform_attributes.c

-- 
2.31.1

