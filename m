Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAADA3A9C5B
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Jun 2021 15:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhFPNpO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Jun 2021 09:45:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54758 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233486AbhFPNpM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 16 Jun 2021 09:45:12 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GDY2gl055467;
        Wed, 16 Jun 2021 09:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=BnvC9AmBanSlttB1nlOhdd0J404KzEzFF+PWFmcqRRE=;
 b=Kw+9EGL6WmdP+AXMuo0jDyjhXVXRjMGSzjUzKMZQ/cCGG4bIfu06jA/NyKQlN0Pu22GQ
 eKlAMuFS3DguuWgnxuQ6JRrQo+Shrap+NX0BFpEK64oqMw1NQFSRVzgyutDJjq55tTtp
 L+QSwaEstTELITk4MDNkTuU9S/Dry6DgIkxHzUXRwJ1zOCrZolYP4t4aCVITOFSqTmto
 BBNmX6eyM8e9jpwMgTI1iQXPIRyqu6dh04e2JxxcGG+EsoZiX0Jmw1WYzBy1TStcsR4o
 wepgtAH5hFXKsuLEXRW73uax2UUHSuxhQjDKYHmA99lPfmKxQR88QQ1ioLXRqlIzfyIQ 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 397fuv50ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 09:42:47 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15GDZ8xQ065342;
        Wed, 16 Jun 2021 09:42:47 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 397fuv50bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 09:42:47 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15GDghF1015703;
        Wed, 16 Jun 2021 13:42:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 394mj8t4bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 13:42:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15GDghH532571706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 13:42:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B5D0A4040;
        Wed, 16 Jun 2021 13:42:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 745DCA4053;
        Wed, 16 Jun 2021 13:42:41 +0000 (GMT)
Received: from pratiks-thinkpad.ibmuc.com (unknown [9.79.208.82])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Jun 2021 13:42:41 +0000 (GMT)
From:   "Pratik R. Sampat" <psampat@linux.ibm.com>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: [PATCH 0/1] Interface to represent PAPR firmware attributes
Date:   Wed, 16 Jun 2021 19:12:39 +0530
Message-Id: <20210616134240.62195-1-psampat@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CcgbmkiMrkDL3nRBk2D4GdNICS4oLwAG
X-Proofpoint-GUID: fF7DxLDj24bdstd717FJFOZhZwtcAWZe
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106160078
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

RFC --> v1
RFC: https://lkml.org/lkml/2021/6/4/791

Changelog:
Overhaul in interface design to the following:
/sys/firmware/papr/energy_scale_info/
   |-- <id>/
     |-- desc
     |-- value
     |-- value_desc (if exists)
   |-- <id>/
     |-- desc
     |-- value
     |-- value_desc (if exists)

Also implemented a POC using this interface for the powerpc-utils'
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
 arch/powerpc/include/asm/hvcall.h             |  21 +-
 arch/powerpc/kvm/trace_hv.h                   |   1 +
 arch/powerpc/platforms/pseries/Makefile       |   3 +-
 .../pseries/papr_platform_attributes.c        | 292 ++++++++++++++++++
 5 files changed, 341 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-papr-energy-scale-info
 create mode 100644 arch/powerpc/platforms/pseries/papr_platform_attributes.c

-- 
2.30.2

