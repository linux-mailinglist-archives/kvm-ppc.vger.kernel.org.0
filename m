Return-Path: <kvm-ppc+bounces-82-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E0988F795
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 07:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0407B20D1D
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 06:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCF64085C;
	Thu, 28 Mar 2024 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dr4J7j0x"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C436924219
	for <kvm-ppc@vger.kernel.org>; Thu, 28 Mar 2024 06:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711605633; cv=none; b=PsWbNc2CO+cSHbZNSMDnvdvVgX6+yfghQISAWUnYMizwaZfU5bZKSZ6QLTvY3pzzkNL6fVSIGvLJJCjxiH6VUHImpj71tJZkE0BSjh02fcnj2D6n4JOoHPRorMBzn8wnLyR1vejJx2Envshrclp3xk38lrwHG/GFawbcmm0c0Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711605633; c=relaxed/simple;
	bh=O7MyNP/4jnrumS21LTn3VQ+uJ5RYCOzcWkFD/MG1C7w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B49JBQEf55IqR6zrLeZ9/nIVoanaVotUTl47P3F5FU6HzJeOXgtYu+QkfCucFwrzrKCr+5xgcmQNGzNnQGSPBi68TrmhX0CCYuP899FJB63j7W9w3IXtuf0qCbSe7ZJZ+khHXBt1zCCn/igngitih0mmx07wT5n4KLHCmEMIKD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dr4J7j0x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42S5U7x9011260;
	Thu, 28 Mar 2024 06:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=jXXqEnQXNWcju3HbvRDIZOClyQ9cvv2loQbz+Jk2dVk=;
 b=Dr4J7j0xh7UGLAzoGnSsvRmRJk8+ir45dfTuKsXDZBMOg+a/Q4mNSQub2DqOltwyzAv6
 kROSSQ1MQVBhqOaZRAJRe2Z/9K164lDbQBmX+6MpnPP4VQ7BF1ggcs6IPi0kGf8A3MAb
 HqAUq0H41KNFFsBLRSH1IB6NXVdj+UKKzAKZTfi8J/C7TtrK9HInvC6XLRHZA5vwJdPL
 RHhO0zigp/9OuL0/b8o6e7QLXJj0mKLVdtikdG88D+nvoqJm+j+JIKue95VlAGzbhSDJ
 7sAw7vrm7LrmgPvK1FhTiQDe5U8jl6/mki3dINNUIyZIgCIxbexlguYjcKWwDj8eebsr jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x529f82g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 06:00:21 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42S60LJj023786;
	Thu, 28 Mar 2024 06:00:21 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x529f82g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 06:00:21 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42S4Wo74028790;
	Thu, 28 Mar 2024 06:00:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x2adpkmnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 06:00:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42S60GlQ34996514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 06:00:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A7152006B;
	Thu, 28 Mar 2024 06:00:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E4C920070;
	Thu, 28 Mar 2024 06:00:15 +0000 (GMT)
Received: from r223l.aus.stglabs.ibm.com (unknown [9.3.109.14])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 28 Mar 2024 06:00:15 +0000 (GMT)
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>, aik@ozlabs.ru,
        Thomas Huth <thuth@redhat.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Kautuk Consul <kconsul@linux.ibm.com>
Subject: [PATCH v4] slof/fs/packages/disk-label.fs: improve checking for DOS boot partitions
Date: Thu, 28 Mar 2024 02:00:09 -0400
Message-Id: <20240328060009.650859-1-kconsul@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qtR93siIHmrMPWURL4RfUlmdkYyRjORl
X-Proofpoint-GUID: 3IRwNYYdmdZItbh8eM4h7xi-2hd7-MT8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-28_04,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403280036

While testing with a qcow2 with a DOS boot partition it was found that
when we set the logical_block_size in the guest XML to >512 then the
boot would fail in the following interminable loop:
<SNIP>
Trying to load:  from: /pci@800000020000000/scsi@3 ...
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
</SNIP>

Change the "read-sector" Forth subroutine to throw an exception whenever
it fails to read a full block-size length of sector from the disk.
Also change the "open" method to initiate CATCH exception handling for the calls to
try-partitions/try-files which will also call read-sector which could potentially
now throw this new exception.

After making the above changes, it fails properly with the correct error
message as follows:
<SNIP>
Trying to load:  from: /pci@800000020000000/scsi@3 ...
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!

E3404: Not a bootable device!

E3407: Load failed

  Type 'boot' and press return to continue booting the system.
  Type 'reset-all' and press return to reboot the system.

Ready!
0 >
</SNIP>

Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
---
 slof/fs/packages/disk-label.fs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
index 661c6b0..a6fb231 100644
--- a/slof/fs/packages/disk-label.fs
+++ b/slof/fs/packages/disk-label.fs
@@ -136,7 +136,8 @@ CONSTANT /gpt-part-entry
 : read-sector ( sector-number -- )
    \ block-size is 0x200 on disks, 0x800 on cdrom drives
    block-size * 0 seek drop      \ seek to sector
-   block block-size read drop    \ read sector
+   block block-size read         \ read sector
+   block-size < IF throw THEN    \ if we read less than the block-size then throw an exception
 ;
 
 : (.part-entry) ( part-entry )
@@ -723,10 +724,15 @@ CREATE GPT-LINUX-PARTITION 10 allot
    THEN
 
    partition IF
-       try-partitions
+       ['] try-partitions
    ELSE
-       try-files
+       ['] try-files
    THEN
+
+   \ Catch any exception that might happen due to read-sector failing to read
+   \ block-size number of bytes from any sector of the disk.
+   CATCH IF false THEN
+
    dup 0= IF debug-disk-label? IF ." not found." cr THEN close THEN \ free memory again
 ;
 
-- 
2.31.1


