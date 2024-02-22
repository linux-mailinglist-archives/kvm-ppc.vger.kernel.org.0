Return-Path: <kvm-ppc+bounces-54-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E2985F768
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 12:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 669082851FA
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 11:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE10F208A2;
	Thu, 22 Feb 2024 11:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F5UzMTyx"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D584652D
	for <kvm-ppc@vger.kernel.org>; Thu, 22 Feb 2024 11:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708602403; cv=none; b=jLREAmSEyDgopyHFJgmdJOchZSLcrYZMY4oXU9VbS4RklO6jBzlWSyW2DmcqYU/vQ+tMNd9dvpC5AeGf0cRdMlV4CrZnY7b5dhAY32Ce18vXZtMemAGizG9rrd1+zt+ZfndKBzuhVZIvWXFMQ/3Q/rcGw5D7ae4rLDD5+Ah6b+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708602403; c=relaxed/simple;
	bh=wVPns61KGKrf0eufvQbtVkqK5PtUEq8LzbxjkWaJUYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UgP3UG/eF8A+ID9OS83mws26Ty10HOBAgsAfANc/5ED8GhIGQ1lignQ7ETvn5cRC38RUUPdL4ZM4O2L6JS/JES+3DQhizYT3jcfBCJrLad8taDKiavZtVchF8EyPGdfmeJdb+FlSnCfJ+VabNeiFdjYXRMaX/BrS/eToDZ32HT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F5UzMTyx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41MBegAK015034;
	Thu, 22 Feb 2024 11:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=Fa6VtVrA+xV1RlZ4bgyFvMt3V3fz3rmAbVcvo9DUJwM=;
 b=F5UzMTyxX2Jd3w8EzDdbkZU/Q6aSfyw9ahQP9kia+Q1zbWB3yM/h/bZYtBVuuLP1KAGH
 LjqFeb5NwVjr5JXC2NnZE9Blw0gaXA+iXEyho/nz5esKaa15tBVUYPI5ydRAVV38J1d+
 013T62lhrtOXowmYWbklKobHWbnE7CljaojkR/jruRPZ+OjKYl+kOXhpiYhtcKiyVycd
 CqaGp/Gbzsg16t4iS3Uv8VodejcBuak37MXG1MINXptBS82y0RuNSKDEq+X1Y3+wLTOt
 L8YJNlNRfdKnNggtptOi7JOqIdu+H11PCradOYbJUaTfVGHFGatL8AlmBFGTbuaW5dki /A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3we5fqr6vh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 11:46:26 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41MBfN2i017336;
	Thu, 22 Feb 2024 11:46:26 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3we5fqr6v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 11:46:25 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41MBKJZP013492;
	Thu, 22 Feb 2024 11:46:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb7h0p2xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 11:46:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41MBkKJZ41943728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Feb 2024 11:46:22 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94CED20043;
	Thu, 22 Feb 2024 11:46:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D41320040;
	Thu, 22 Feb 2024 11:46:19 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 Feb 2024 11:46:19 +0000 (GMT)
Date: Thu, 22 Feb 2024 17:16:17 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, aik@ozlabs.ru,
        groug@kaod.org, slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YbyoFiubrlkQ_z70CKSGY_R1PenAVddX
X-Proofpoint-ORIG-GUID: jy5X-0xmOegAMLP7luUFi2An8fs-TTnF
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_09,2024-02-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402220094

Hi Thomas,

> 
>  Hi Kautuk,
> 
> could you maybe do some performance checks to see whether this make a
> difference (e.g. by running the command in a tight loop many times)?
> You can use "tb@" to get the current value of the timebase counter, so
> reading that before and after the loop should provide you with a way of
> measuring the required time.
> 
>  Thomas
> 
This patch is to improve compilation timings of the 
IF/AHEAD/THEN/CASE/ENDCASE/BEGIN/AGAIN/UNTIL/DO/?DO/LOOP/+LOOP/ Forth words
that are NOT within any Forth procedure.
And it does this in the same way for all of these Forth words because
all of these words simply utilize the +COMP and -COMP words.

I created a patch on top of this patch file that introduces the older
implementation of IF and THEN and I called them IF2 and THEN2 as
follows:
col(+COMP-BEFORE STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
col(-COMP-BEFORE -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE SEMICOLON THERE @ DOTO HERE COMP-BUFFER EXECUTE)
imm(IF2 +COMP-BEFORE DOTICK DO0BRANCH COMPILE, HERE 0 COMPILE,)
imm(THEN2 ?COMP RESOLVE-ORIG -COMP-BEFORE)

The IF2 and THEN2 use -COMP-BEFORE and +COMP-BEFORE in order to have the
changes before I applied my "[PATCH v2] slof/engine.in: refine +COMP and -COMP by not using"
patch file.

Now that I have both implementation, I used the timebase in order to
test what is the difference in timebase before and after invocation of
numerous IF-THEN and IF2-THEN2 Forth words. I made the following changes
to ./board-qemu/slof/OF.fs:
diff --git a/board-qemu/slof/OF.fs b/board-qemu/slof/OF.fs
index df33c80..56805fc 100644
--- a/board-qemu/slof/OF.fs
+++ b/board-qemu/slof/OF.fs
@@ -22,6 +22,7 @@ hex
 
 #include "base.fs"
 
+
 \ Set default load-base to 0x4000
 4000 to default-load-base
 
@@ -329,6 +330,151 @@ check-boot-from-ram
 
 8ff cp
 
+." BEFORE-PATCH: BEFORE TB is: " tb@ .
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+1 IF2 0 drop THEN2
+cr ." BEFORE-PATCH: AFTER TB is: " tb@ . cr
+
+." AFTER-PATCH: BEFORE TB is: " tb@ .
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+cr ." AFTER-PATCH: AFTER TB is: " tb@ . cr
+
+." AFTER-PATCH: BEFORE TB is: " tb@ .
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+1 IF 0 drop THEN
+cr ." AFTER-PATCH: AFTER TB is: " tb@ . cr

With the above changes in slof/engine.in and board-qemu/slof/OF.fs I
complied SLOF and got the following output on running a guest:
[root@r223l performance_work]# virsh start vm4 --console                
Domain 'vm4' started
Connected to domain 'vm4'
Escape character is ^] (Ctrl + ])
Populating /vdevice methods
Populating /vdevice/vty@30000000
Populating /vdevice/nvram@71000000
Populating /pci@800000020000000
                     00 0800 (D) : 1b36 000d    serial bus [ usb-xhci ]
                     00 1000 (D) : 1af4 1003    virtio [ serial ]
                     00 1800 (D) : 1af4 1001    virtio [ block ]
                     00 2000 (D) : 1af4 1002    legacy-device*
                     00 2800 (D) : 1234 1111    qemu vga
No NVRAM common partition, re-initializing...
Installing QEMU fb



Scanning USB
  XHCI: Initializing
    USB Keyboard
No console specified using screen & keyboard
BEFORE-PATCH: BEFORE TB is: 9de978a1
BEFORE-PATCH: AFTER TB is: 9e78efba
AFTER-PATCH: BEFORE TB is: 9ebb67aa
AFTER-PATCH: AFTER TB is: 9f2247cc
AFTER-PATCH: BEFORE TB is: 9f64b9fd
AFTER-PATCH: AFTER TB is: 9fc33e6c

  Welcome to Open Firmware

  Copyright (c) 2004, 2017 IBM Corporation All rights reserved.
  This program and the accompanying materials are made available
  under the terms of the BSD License available at
  http://www.opensource.org/licenses/bsd-license.php


Trying to load:  from: /pci@800000020000000/scsi@3 ...   Successfully loaded

[root@r223l performance_work]# echo $((0x9e78efba-0x9de978a1))
9402137
[root@r223l performance_work]# echo $((0x9f2247cc-0x9ebb67aa))                                                                                                                                             
6742050
[root@r223l performance_work]# echo $((0x9fc33e6c-0x9f64b9fd))                                                                                                                                             
6194287
[root@r223l performance_work]# echo "scale=4;(9402137-6742050)/512" | bc                                                                                                                                   
5195.4824
[root@r223l performance_work]# echo "scale=4;(9402137-6194287)/512" | bc                                                                                                                                   
6265.3320
[root@r223l performance_work]#

As per the calculations in the output of the BEFORE-PATCH and
AFTER-PATCH logs I find that there is a very noticeable and consistent improvement
in multiple runs in terms of microseconds. (My POWER9 bare-metal has 512 MHz timebase-frequency
so thats why I am dividing by 512).

Note: The above figures include the execution speed of IF-THEN and
IF2-THEN2 after compilation. But since the actual execution speeds of the IF-THEN and the IF2-THEN2 after
their compilation should be the same, this should get adjusted in my
subtraction in the above 2 bc commands.
> 

