Return-Path: <kvm-ppc+bounces-217-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D60A2760E
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 Feb 2025 16:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48A2F168207
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 Feb 2025 15:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37623213E7D;
	Tue,  4 Feb 2025 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="azqw3Oa5"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3020214200;
	Tue,  4 Feb 2025 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683369; cv=none; b=RN7Cog5CfFX9IING+JK0/Q9Rm5o0OBgi5pIxfF2ygjBbIwXvkcQA+fZJJsgcoYLeIro44EjWwochjNapzaStkAmu80X5MVjMSO7jh92AXS3uKGPMTOZueLC4roxCdKNVRULs7C4M8X0nzGVIVDr6R+eJlZ9+2tM6Po1sEFxv1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683369; c=relaxed/simple;
	bh=DT5XMBCxc/60gBVQPmcpHiHtDNLvlyPRlrcGQUhuU/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n+Jb7NwKC+NeftX/QhYsDgnN2YcgPrIZ9knDwZUsuZpiMfS7O62h8/as5AqXVGxsABcC6wGGCaIwiAomgxeJFQINcaDyJCMpNTjhlVC69rnFNlJZLjaYW5PhafVXB1xPq2jisAB5Y5nvGG06EfQfrkrrk0jI1EtRVZQ2sgdr9qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=azqw3Oa5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514FXdmX032006;
	Tue, 4 Feb 2025 15:35:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=zXfTgOKl+DjPA2fGZqnU5gjDzW6o4ycWla1wGPd4e
	zU=; b=azqw3Oa5q8o1X/nBXtGEEsJNZdCTR9WQitfn0dD7G4qvSsRE+/Ef2LXQ9
	czp+vcuR9TYje0sU+Z1Z47BoWr4telC69U6mBjaOl+MScv4I7MtwFTOJxDDAvNLj
	BqRqxxTBag/vGXmBq/nvl3KRMp59hl2lObRizkHjhdwLuG0AlcggHqDeMOnXrbeG
	uJnbmbxjYyscsGq71y1KvUdaDvYq+HFBaP22jU50Nh5mHQDrR7fisg2rZPw6jKlN
	iw/xkGZYFJstDtNrZz/XF/MDtP1GUtFhybSibkp+7+zgfOGzw4eiSd8q1VaBD8S4
	Yq83sJTBIYm4R1VMawQJLWwU7bQjQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44k9r0ucwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 15:35:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 514CWJdI024492;
	Tue, 4 Feb 2025 15:35:49 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxn466k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 15:35:49 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 514FZi6U45220110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Feb 2025 15:35:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 553DE20170;
	Tue,  4 Feb 2025 15:35:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98FA52016D;
	Tue,  4 Feb 2025 15:35:30 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.20.128])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  4 Feb 2025 15:35:30 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Tue, 04 Feb 2025 21:05:29 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, atrajeev@linux.vnet.ibm.com,
        kjain@linux.ibm.com, disgoel@linux.ibm.com, hbathini@linux.ibm.com,
        adubey@linux.ibm.com, gautam@linux.ibm.com
Subject: [PATCH] powerpc/perf: Fix ref-counting on the PMU 'vpa_pmu'
Date: Tue,  4 Feb 2025 21:05:26 +0530
Message-ID: <20250204153527.125491-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j8VMVzV3XjJOM6tez38eW0nLfH7Sx5HE
X-Proofpoint-GUID: j8VMVzV3XjJOM6tez38eW0nLfH7Sx5HE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_07,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 adultscore=0 spamscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502040120

Commit 176cda0619b6 ("powerpc/perf: Add perf interface to expose vpa
counters") introduced 'vpa_pmu' to expose Book3s-HV nested APIv2 provided
L1<->L2 context switch latency counters to L1 user-space via
perf-events. However the newly introduced PMU named 'vpa_pmu' doesn't
assign ownership of the PMU to the module 'vpa_pmu'. Consequently the
module 'vpa_pmu' can be unloaded while one of the perf-events are still
active, which can lead to kernel oops and panic of the form below on a
Pseries-LPAR:

BUG: Kernel NULL pointer dereference on read at 0x00000058
<snip>
 NIP [c000000000506cb8] event_sched_out+0x40/0x258
 LR [c00000000050e8a4] __perf_remove_from_context+0x7c/0x2b0
 Call Trace:
 [c00000025fc3fc30] [c00000025f8457a8] 0xc00000025f8457a8 (unreliable)
 [c00000025fc3fc80] [fffffffffffffee0] 0xfffffffffffffee0
 [c00000025fc3fcd0] [c000000000501e70] event_function+0xa8/0x120
<snip>
 Kernel panic - not syncing: Aiee, killing interrupt handler!

Fix this by adding the module ownership to 'vpa_pmu' so that the module
'vpa_pmu' is ref-counted and prevented from being unloaded when perf-events
are initialized.

Fixes: 176cda0619b6 ("powerpc/perf: Add perf interface to expose vpa counters")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 arch/powerpc/perf/vpa-pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/perf/vpa-pmu.c b/arch/powerpc/perf/vpa-pmu.c
index 6a5bfd2a13b5..840733468959 100644
--- a/arch/powerpc/perf/vpa-pmu.c
+++ b/arch/powerpc/perf/vpa-pmu.c
@@ -156,6 +156,7 @@ static void vpa_pmu_del(struct perf_event *event, int flags)
 }
 
 static struct pmu vpa_pmu = {
+	.module		= THIS_MODULE,
 	.task_ctx_nr	= perf_sw_context,
 	.name		= "vpa_pmu",
 	.event_init	= vpa_pmu_event_init,
-- 
2.48.1


