Return-Path: <kvm-ppc+bounces-51-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E162385F145
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 07:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F2211C20ED4
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 06:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F4F12B7E;
	Thu, 22 Feb 2024 06:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lL8E67Yc"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABC712E4F
	for <kvm-ppc@vger.kernel.org>; Thu, 22 Feb 2024 06:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708582261; cv=none; b=l+HXIb6NqrLjehxW4QxPnVeFgA17osm8u2yuEllE50waJZ0qIlYMJH/ZfF+p/Nofk6rw7UedwHAkp0Sj2jbMlXzWpCYPSiuFFUznipJpl+JjPUAh4cQRudD0mYNf6HROcZvlo9fn76rSOllmDM6JIDSiLXnUYcXRi73CvdVdsS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708582261; c=relaxed/simple;
	bh=UpjdHHw/gCdNWMqUhwmJH1tsmL+FIF0GEbffiVutFL0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XXiBeC96VyVEY9weYBG132+fUFE2rZ3ebOYxw+TL2O66BkwdmO9759/nSyCTOW7t6EdxB6X9UfbL1HVjAgMh+NwJt2JOUuv6pv5gRPOETG+D/qIC8gbY6JZ7bj3SvzmSylLQluUpItYbq6XK2iy9jbkRgmXaWbZj54c8wEbNJeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lL8E67Yc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41M5adZc006771;
	Thu, 22 Feb 2024 06:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=DpQsqAgQyzMIfrcOFy9LNqTB/lK7iH0vLQhb5W0DTgE=;
 b=lL8E67Yc1eA6ZlDt+riCRc76/4GbYCkDVxZIt3TxTUpizr3gyL2eIqTDXXZ2bC0a933F
 KopdFG3aVg/GqYf2v/86yeRKt6U/0TaY8TwNuZu8qM1ErZK9M+284HiZSPMJn0gv8eJ0
 32a8EVji9dhjuiv2QvWL5X9DJB1nCwt69R8A79HS11GljXe0Rd93I1M1MugNxLh4cum7
 o530n6Dd3M+i/J86ib9KamC9XuyLmvWZsAm9MKo8HaYtGfX6uK2p7q4FLfhwbbDW0Auc
 neqYxC2jXs+sj5ZMQ1JDAxeX74OBGdgIJB/ZW4h9nUtvq47qaFMWOnkZsjfLN5Afbhvz MA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wdywt95g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 06:10:54 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41M5cSGc012389;
	Thu, 22 Feb 2024 06:10:54 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wdywt95fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 06:10:54 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41M2uAvL017278;
	Thu, 22 Feb 2024 06:10:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb8mmm55q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 06:10:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41M6AnjP29164094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Feb 2024 06:10:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D94220043;
	Thu, 22 Feb 2024 06:10:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B4C120040;
	Thu, 22 Feb 2024 06:10:48 +0000 (GMT)
Received: from r223l.aus.stglabs.ibm.com (unknown [9.3.109.14])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 Feb 2024 06:10:48 +0000 (GMT)
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Kautuk Consul <kconsul@linux.vnet.ibm.com>
Subject: [PATCH] slof/fs/packages/disk-label.fs: improve checking for DOS boot partitions
Date: Thu, 22 Feb 2024 01:10:46 -0500
Message-Id: <20240222061046.42572-1-kconsul@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9WupeTNAiK3fVRsJNtP7WPmTTLBwRJmX
X-Proofpoint-ORIG-GUID: CnRcyRRZaXNL-LOOXcRMbz6s4kp1pRXQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_03,2024-02-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402220046

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

Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
---
 slof/fs/packages/disk-label.fs | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
index 661c6b0..e680847 100644
--- a/slof/fs/packages/disk-label.fs
+++ b/slof/fs/packages/disk-label.fs
@@ -139,6 +139,13 @@ CONSTANT /gpt-part-entry
    block block-size read drop    \ read sector
 ;
 
+\ read sector to array "block" and return actual bytes read
+: read-sector-ret ( sector-number -- actual)
+   \ block-size is 0x200 on disks, 0x800 on cdrom drives
+   block-size * 0 seek drop      \ seek to sector
+   block block-size read    \ read sector
+;
+
 : (.part-entry) ( part-entry )
    cr ." part-entry>active:        " dup part-entry>active c@ .d
    cr ." part-entry>start-head:    " dup part-entry>start-head c@ .d
@@ -204,7 +211,8 @@ CONSTANT /gpt-part-entry
          part-entry>sector-offset l@-le    ( current sector )
          dup to part-start to lpart-start  ( current )
          BEGIN
-            part-start read-sector          \ read EBR
+            part-start read-sector-ret          \ read EBR
+            block-size < IF UNLOOP 0 EXIT THEN
             1 partition>start-sector IF
                \ ." Logical Partition found at " part-start .d cr
                1+
@@ -279,6 +287,7 @@ CONSTANT /gpt-part-entry
    THEN
 
    count-dos-logical-partitions TO dos-logical-partitions
+   dos-logical-partitions 0= IF false EXIT THEN
 
    debug-disk-label? IF
       ." Found " dos-logical-partitions .d ." logical partitions" cr
@@ -352,6 +361,7 @@ CONSTANT /gpt-part-entry
    no-mbr? IF drop FALSE EXIT THEN  \ read MBR and check for DOS disk-label magic
 
    count-dos-logical-partitions TO dos-logical-partitions
+   dos-logical-partitions 0= IF 0 EXIT THEN
 
    debug-disk-label? IF
       ." Found " dos-logical-partitions .d ." logical partitions" cr
-- 
2.31.1


