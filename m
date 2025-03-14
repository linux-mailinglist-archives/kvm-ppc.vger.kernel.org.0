Return-Path: <kvm-ppc+bounces-241-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCCE5A607ED
	for <lists+kvm-ppc@lfdr.de>; Fri, 14 Mar 2025 04:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC10719C42BB
	for <lists+kvm-ppc@lfdr.de>; Fri, 14 Mar 2025 03:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE831624CB;
	Fri, 14 Mar 2025 03:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TM5SvJd0"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFCC15B122;
	Fri, 14 Mar 2025 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741924042; cv=none; b=o7fc6AZ0FGcF0qgWq0MZVq4mKC7v8ViqEzyx+PwyspAZ0ExeR/6EtkpwQJVd+AY2OV5Eu8QEIwuOOF4lejGN69KNaBFSr/CTEzRgh5UC5DUPtDuN2bJU+Oh1XVC8gubKIiqxJUxPK9fv4t0jsKDDMSsclMADO/tw5ErOXxt9GT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741924042; c=relaxed/simple;
	bh=ZmS/wratiAQQitlwbf1ct9NeXdvsYbqlWKXJRtQZOyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aamPaOK8ArX0Y2cCTKKEXulIQ5cA7DUHotEnuVSM92QzWSOzSKDuGRPt15m+d3J3d/WvtdotpLC1+0Y9B8enWjt1ZMekF8yG4Rvuf038D1RgC8FYcOw3in4KMz3MZw3S89JKSU9jFwzfUQVC/0Ypxh5DYfZ5gTP0R8Pg6z6JqUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TM5SvJd0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DNOvn4030500;
	Fri, 14 Mar 2025 03:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dv7DcN
	zfKpDoRegGq6BAd81m+l+Gv0AVddi4b2R9sR8=; b=TM5SvJd0WtkNFjMzAXdcDJ
	KDcttJtuzysR9rRYgUkcMmqmCGzYvxlZj4ksobNdOGa0NKDZMPgi5QSR5GRczM2u
	H2QvFuCPzqeVycoEhWlkPvC2TwbEV3vQMILNRNEAY0AqzhJjdvJ+QfIt/iE4cvVF
	GzO4HIISGxrua/x95srz6jtu0VMaiQ1KWGX14U2qfR9AdWmkkBfU1YrIWlQ2PSQZ
	8oheMMJwLVNwMKgIF60rWgYQ6cqxM0AviXL0LOiZ+QXKVqmVetCXDPnRfUASbFQt
	GcMTsVx9vRMRcsyXPha2KH/I7xS71GONVB55aM90qqLGqDW1zOwuHzf+7p7M1K0A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45byd8v1pe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 03:47:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52DN8JU0003124;
	Fri, 14 Mar 2025 03:47:10 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 45atstw3aw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 03:47:10 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52E3l6Zt20054292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Mar 2025 03:47:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07E1A20040;
	Fri, 14 Mar 2025 03:47:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91F2A2004B;
	Fri, 14 Mar 2025 03:47:03 +0000 (GMT)
Received: from li-c439904c-24ed-11b2-a85c-b284a6847472.in.ibm.com (unknown [9.204.206.207])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Mar 2025 03:47:03 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, atrajeev@linux.vnet.ibm.com,
        kjain@linux.ibm.com, disgoel@linux.ibm.com, hbathini@linux.ibm.com,
        adubey@linux.ibm.com, gautam@linux.ibm.com
Subject: Re: [PATCH] powerpc/perf: Fix ref-counting on the PMU 'vpa_pmu'
Date: Fri, 14 Mar 2025 09:17:02 +0530
Message-ID: <174192385436.14370.8988935499499753559.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250204153527.125491-1-vaibhav@linux.ibm.com>
References: <20250204153527.125491-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Trxq7CHcStED-hArgwHO7jSU1xA5Mvgo
X-Proofpoint-ORIG-GUID: Trxq7CHcStED-hArgwHO7jSU1xA5Mvgo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-14_01,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=972 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503140026

On Tue, 04 Feb 2025 21:05:26 +0530, Vaibhav Jain wrote:
> Commit 176cda0619b6 ("powerpc/perf: Add perf interface to expose vpa
> counters") introduced 'vpa_pmu' to expose Book3s-HV nested APIv2 provided
> L1<->L2 context switch latency counters to L1 user-space via
> perf-events. However the newly introduced PMU named 'vpa_pmu' doesn't
> assign ownership of the PMU to the module 'vpa_pmu'. Consequently the
> module 'vpa_pmu' can be unloaded while one of the perf-events are still
> active, which can lead to kernel oops and panic of the form below on a
> Pseries-LPAR:
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/perf: Fix ref-counting on the PMU 'vpa_pmu'
      https://git.kernel.org/powerpc/c/ff99d5b6a246715f2257123cdf6c4a29cb33aa78

Thanks

