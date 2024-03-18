Return-Path: <kvm-ppc+bounces-72-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 597BC87E75C
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 11:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F910B20B9E
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 10:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1968A2A;
	Mon, 18 Mar 2024 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PfOaAV2x"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD181FB5
	for <kvm-ppc@vger.kernel.org>; Mon, 18 Mar 2024 10:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710757823; cv=none; b=ugEV1bSVmKNYtvRbM+6rEYcmLNL+5aE3yVjpr7T6VDFiH0GhzuiWNd3ICZC39DGhCLv7GdoFyCaVjg/VCMTKM1IL13kUgM2zZjDcd0b/RW/tlSAz6OJPTaQiOUD0oB28+bjg8J1vT5QcmdAegmJoxZ0tHLD/eeU0lfKW36sj2K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710757823; c=relaxed/simple;
	bh=QvX0oZXylkhEqPRWDw1O64VBpWgsNN0sazKsu8Gk0PE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=K9WtGZ0YKbFicU7QUV/r9w0pPFxGhNaiKURu7CbLmhmgxHqkrhWE8JMTjOrKaqR1iLTVv9PacbjcrnC4SsHALefa7PBZnA46rxDG+nHcDbL0QQ1kXtVXbxSUDURgJksP55o4XGPp1Fl89K6/6v+cULTmZQZiQiInchRjYoGCtqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PfOaAV2x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42I9H2LE021461;
	Mon, 18 Mar 2024 10:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Wm+UGe9BMmb8ZZc01eg3aTu3oNpLCQvSMfPI26dr3zY=;
 b=PfOaAV2xqYkH1leKxogoqawRIAJrzz8j3nHjV+o0cYR0ZWWQNDzUl2YOzn6v2U2lGHq9
 l01kJ152nzCEonfk26q9FlGqm0E6l84lA5F+x/vkcTWosKp0ki0CiP9pZLiADF5vHpdY
 rlQ0+NpsspZpfR1kmL+c1ALMQcGc8YIvi5bnSVvN7a6XN1graGdZ2cqjahPdjdP+5uzp
 1tEQAR86s6cunyNbJjeGC5n+zGxyviQO4Gb/3mpqPqezLghRFTm+DilJsVFDYPo6DsmU
 hOZ7KchnnZY1BaYe8m26d31aaE5UrBEdDMyD5BJAL9P1l4lSulAUQ7nTlW/SOth3YLtw /A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wwn5fukc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 10:30:13 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42IAA9Xp004136;
	Mon, 18 Mar 2024 10:30:13 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wwn5fukbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 10:30:12 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42I7wgXH002815;
	Mon, 18 Mar 2024 10:30:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wwrf27r9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 10:30:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42IAU8Q746137604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Mar 2024 10:30:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8670E20040;
	Mon, 18 Mar 2024 10:30:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B1F920049;
	Mon, 18 Mar 2024 10:30:07 +0000 (GMT)
Received: from r223l.aus.stglabs.ibm.com (unknown [9.3.109.14])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 18 Mar 2024 10:30:07 +0000 (GMT)
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Kautuk Consul <kconsul@linux.vnet.ibm.com>
Subject: [PATCH v2] slof/fs/packages/disk-label.fs: improve checking for DOS boot partitions
Date: Mon, 18 Mar 2024 06:30:03 -0400
Message-Id: <20240318103003.484602-1-kconsul@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oKeIvBBX6hIVdT2JhTPU2NBM5S_8z2Wq
X-Proofpoint-ORIG-GUID: jEPCTUOxTXLkEd5aOaUJVl94LnoVP8m_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-18_01,2024-03-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403180078

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
 slof/fs/packages/disk-label.fs | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
index 661c6b0..2630701 100644
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
+            block-size < IF UNLOOP 0 EXIT THEN
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
+   dos-logical-partitions 0= IF 0 EXIT THEN
 
    debug-disk-label? IF
       ." Found " dos-logical-partitions .d ." logical partitions" cr
-- 
2.31.1


