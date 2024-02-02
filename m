Return-Path: <kvm-ppc+bounces-40-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3BC846773
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Feb 2024 06:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA9531F21B6C
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Feb 2024 05:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6A4171BF;
	Fri,  2 Feb 2024 05:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qHldoEwn"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE68171CD
	for <kvm-ppc@vger.kernel.org>; Fri,  2 Feb 2024 05:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706850973; cv=none; b=DM70y8k5bkWNgppIz06XE0kPHjN2JNDVRYQqRpgt2K+u2QDH9/w5YzGtp/llMfakHk8dw4G4nbB3h+tfto1NGjq4hvVVlD8MdKRTkvgf8R/QFR7jAlEFKi+/j5IJyEbX0KLngzuZl7epaiKTnoKyzsMVSOk2HBxNlQ5vzUC7zXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706850973; c=relaxed/simple;
	bh=lBa9z97aI04YQPWv66mk9xlc14kQ7IRIn3iCtoaYSF4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J02kyjvgVWYubWEyRzWgx/LdMekD28VjlMonRkQu+dy73Z4uXqph362pXpo024ZNNZdAAD7VhE+3CPaCIYpdrs8k8qIGYFWoXN80uvAyxyQp9lsSGg0obevwPzY/aNyJhNf8h0YuuxcVivY39MJ2ZZ2ECLWBZaH4W754kAS079c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qHldoEwn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4124fgsB030291;
	Fri, 2 Feb 2024 05:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=flTRcDDgabpzJcoVA/929pCV0giDxtc0vMtN5csNVdI=;
 b=qHldoEwnMCUNJ+nymunFIqElYnl1pNDdVw1TH/KHXMU+MEKOBso8HFhaXT3aKzgGImAm
 JOk6ZUOq3AofPjxDvflf/tMG4TX38OIyBR8IC47h5CFtAlJKbatzY+Ra+7lc0Ls+OYvf
 7TTWxS+iwSH77Jty2Sa9iB703ta2qKelZ3r+3loCpFpFmQ9lbv8WFigM34teQZtxj6Kk
 bIm9FtQJYUdVZvP1XShJKPQ8gevCoaWZnN71fcsSFJJbBwwWx8lkm6hFH6+TWSGJg/70
 7bFTNS2dFnEHqoFtl5byUujxe3HXwgKQ6ZxDz1MBsnIvnoIkYXYvfbEwSpD/FYm5X/N+ Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0s1a9hqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 05:15:57 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4124iWxp005632;
	Fri, 2 Feb 2024 05:15:57 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0s1a9hqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 05:15:57 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4122oBFj017772;
	Fri, 2 Feb 2024 05:15:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwcj09ck7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 05:15:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4125FrEA27394618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 05:15:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF2492004B;
	Fri,  2 Feb 2024 05:15:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A78F920043;
	Fri,  2 Feb 2024 05:15:52 +0000 (GMT)
Received: from r223l.aus.stglabs.ibm.com (unknown [9.3.109.14])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 05:15:52 +0000 (GMT)
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>,
        Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Kautuk Consul <kconsul@linux.vnet.ibm.com>
Subject: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using COMPILE
Date: Fri,  2 Feb 2024 00:15:48 -0500
Message-Id: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J4wA75j9sjWvYvzXXSEC4pwRpJcSAo-V
X-Proofpoint-GUID: 2YBxbN2P7edBTp8JLm9yDqOHH1AaDr6Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 clxscore=1011
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402020036

Use the standard "DOTICK <word> COMPILE," mechanism in +COMP and -COMP
as is being used by the rest of the compiler.
Also use "SEMICOLON" instead of "EXIT" to compile into HERE in -COMP
as that is more informative as it mirrors the way the col() macro defines
a colon definition.

Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
---
 slof/engine.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/slof/engine.in b/slof/engine.in
index 59e82f1..fa4d82e 100644
--- a/slof/engine.in
+++ b/slof/engine.in
@@ -422,8 +422,8 @@ imm(.( LIT(')') PARSE TYPE)
 col(COMPILE R> CELL+ DUP @ COMPILE, >R)
 
 var(THERE 0)
-col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
-col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
+col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE DOTICK DOCOL COMPILE,)
+col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT DOTICK SEMICOLON COMPILE, THERE @ DOTO HERE COMP-BUFFER EXECUTE)
 
 // Structure words.
 col(RESOLVE-ORIG HERE OVER CELL+ - SWAP !)
-- 
2.31.1


