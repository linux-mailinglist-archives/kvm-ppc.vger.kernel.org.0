Return-Path: <kvm-ppc+bounces-76-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D014F88D5F1
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 06:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 006D8B21FDE
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 05:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D6AFC18;
	Wed, 27 Mar 2024 05:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r8gVZHr7"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045B836B
	for <kvm-ppc@vger.kernel.org>; Wed, 27 Mar 2024 05:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711518117; cv=none; b=Zlf97habEdvWmQO2xyqcpVO5bHNoU7aRVPbP2UEBQSoZq8luOeGJZdW1fdKXbdOgJtgvu8Ipc2gNDm2I7zWcotV+tGFassFf+A5gPbYx3u3zMUGjSF6nMc0Qw8roLd6/aJZAyHbGyRbymNEgjJ/TJctFwxPOYByvC8ogKmOKNQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711518117; c=relaxed/simple;
	bh=jotOnOrhP1FowiKlCwhO4HkvUN3eDZikvllAZBX6MqI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j7D6e3ysflNqydMNTEw1ibLWGAGZVg6UsOOOBOcrkbPXyH9CWNJrRnt3fjM96smqbHDGTfYlxiivf9AuLiZno4J90Bb+qDwWJZov7AvDg3rRkdFL2DM3fY3DplIgdBbRgpAxCd2Qyb4rRsZ0BNTwD6L917/Shbz+yMlbJR+f2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r8gVZHr7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42R5O4TL008151;
	Wed, 27 Mar 2024 05:41:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3l9iS3MtSGpR7wiIu0RVx0B8HU5DRJfQgew6/h52ZdI=;
 b=r8gVZHr7VNH2PoXqHwVebg9W/4U17lmpLJcX4AeM+6A0uOB0lOB6ha7TEDTEWxC29q+w
 lnUhEAXiytCTS85eCTz+shRxT2cBgi+gn8u0cYZjMk7iQgeGmLVqJJHPYwwe+YhcKVd5
 VssOYqeMdB6GO8OcVrRDTKQeWtrWrlV9zmqIDLqa8F29bxw5Vznc/TuT21HvdD4E7XKT
 3uP5IDLzgkklvX0STNIy8d+OtM0JqFDDANAKbJHe3vCGzyjJfdFJ0Tp6TkhnP6S1+G75
 oaZh+/uJ3ew41+7YoI5spQgBP62W1l3DtOggcSdR6jgnQjYUhg2TkD7uzmbGQbkqyb3m zA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x49xwrb1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 05:41:47 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42R5cgaY030490;
	Wed, 27 Mar 2024 05:41:47 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x49xwrb1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 05:41:47 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42R4x2ZO011238;
	Wed, 27 Mar 2024 05:41:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x2bmm4a11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 05:41:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42R5fgPu46858646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 05:41:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A6782004B;
	Wed, 27 Mar 2024 05:41:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF5602004E;
	Wed, 27 Mar 2024 05:41:41 +0000 (GMT)
Received: from r223l.aus.stglabs.ibm.com (unknown [9.3.109.14])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 27 Mar 2024 05:41:41 +0000 (GMT)
From: Kautuk Consul <kconsul@linux.ibm.com>
To: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Kautuk Consul <kconsul@linux.ibm.com>
Subject: [PATCH v3] slof/fs/packages/disk-label.fs: improve checking for DOS boot partitions
Date: Wed, 27 Mar 2024 01:41:27 -0400
Message-Id: <20240327054127.633598-1-kconsul@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IDU1BiyWz2R2RD2JdEwINYxH87iVs0FJ
X-Proofpoint-GUID: BTmey7mRh6cXOxQ9AOZLpGDZAgLR0KSm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_02,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1011
 adultscore=0 phishscore=0 mlxscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270036

While testing with a qcow2 with a DOS boot partition it was found that
when we set the logical_block_size in the guest XML to >512 then the
boot would fail in the following interminable loop:
<SNIP>
Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
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

Change the count-dos-logical-partitions Forth subroutine and the Forth
subroutines calling count-dos-logical-partitions to check for this access
beyond end of device error.

After making the above changes, it fails properly with the correct error
message as follows:
<SNIP>
Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
virtioblk_transfer: Access beyond end of device!
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
 slof/fs/packages/disk-label.fs | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
index 661c6b0..fa15982 100644
--- a/slof/fs/packages/disk-label.fs
+++ b/slof/fs/packages/disk-label.fs
@@ -132,11 +132,16 @@ CONSTANT /gpt-part-entry
    debug-disk-label? IF dup ." actual=" .d cr THEN
 ;
 
-\ read sector to array "block"
-: read-sector ( sector-number -- )
+\ read sector to array "block" and return actual bytes read
+: read-sector-ret ( sector-number -- actual-bytes )
    \ block-size is 0x200 on disks, 0x800 on cdrom drives
    block-size * 0 seek drop      \ seek to sector
-   block block-size read drop    \ read sector
+   block block-size read    \ read sector
+;
+
+\ read sector to array "block"
+: read-sector ( sector-number -- )
+   read-sector-ret drop
 ;
 
 : (.part-entry) ( part-entry )
@@ -204,7 +209,8 @@ CONSTANT /gpt-part-entry
          part-entry>sector-offset l@-le    ( current sector )
          dup to part-start to lpart-start  ( current )
          BEGIN
-            part-start read-sector          \ read EBR
+            part-start read-sector-ret          \ read EBR
+            block-size < IF UNLOOP drop 0 EXIT THEN
             1 partition>start-sector IF
                \ ." Logical Partition found at " part-start .d cr
                1+
@@ -279,6 +285,7 @@ CONSTANT /gpt-part-entry
    THEN
 
    count-dos-logical-partitions TO dos-logical-partitions
+   dos-logical-partitions 0= IF false EXIT THEN
 
    debug-disk-label? IF
       ." Found " dos-logical-partitions .d ." logical partitions" cr
@@ -352,6 +359,7 @@ CONSTANT /gpt-part-entry
    no-mbr? IF drop FALSE EXIT THEN  \ read MBR and check for DOS disk-label magic
 
    count-dos-logical-partitions TO dos-logical-partitions
+   dos-logical-partitions 0= IF drop 0 EXIT THEN
 
    debug-disk-label? IF
       ." Found " dos-logical-partitions .d ." logical partitions" cr
-- 
2.31.1


