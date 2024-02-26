Return-Path: <kvm-ppc+bounces-58-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D3B866967
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 05:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8B0C1C215A7
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 04:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF4618E02;
	Mon, 26 Feb 2024 04:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mzyASb32"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469147460
	for <kvm-ppc@vger.kernel.org>; Mon, 26 Feb 2024 04:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708921996; cv=none; b=A3K95+gSxjwlohofPT8uskGymEZQt2SVRG9W1oPVK7cw2ftEwkLd3qCkaqa9uvxG6wPjzha6ENsIqLK3IG9702c1oFzLeUnU4H8THgk+2GVY8SBnSbGiOUGGC6rGFaMINYOQ1WQLBPnGc5aHTcZThZ3lcln8e9fOn3pPOH9X2Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708921996; c=relaxed/simple;
	bh=vh1ISOUZiAzEMYysMDMYPqtirgpQtpm2Cpw+j68yqSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUB6buF5ti4bOVYjMC8y1R7zx+u6kXLhioRJ1vGYatAIJj9DFOxBe3gZbn1IlfApCutZEXA5NuXMWG9Nv/j3oS+6QGjia4JuApwETmw+2UYFzMFN/WUW13dcXmCEz/eeUI6h7jsM72PdMAfVWh6L4HzfWsXy674n7YAjtRJwdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mzyASb32; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q49Vpe008970;
	Mon, 26 Feb 2024 04:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=gct6nYL26NYqL1ITqb9M61Tei13ntwkaZT4AHzVcNLg=;
 b=mzyASb32fjaDBJTWV03QEZfdmrISqEykXG+euzKF5FoOs80EgF16jSvA+uSjJCukmk+i
 +JKBVuuAxRg3vCAJHvtbW9ckNnETfQn+apjol6rsWRe3R8OuMQARPX/3uwMYM4RdEh1/
 TgT0h3xaf4dH3YtnowJS0NDq5yjeTEl40mhR5xWfxtaq9FMf80pftiU9HWGSeZNTiCmm
 t1b8JfxS6q83t/gApeskiBWodajFQbjmO++MhMYMHJxwj27qvgz7eKZyq6JF7d7CO55p
 r17wHvS3hex2af9Z0JmpVVw2M00KDwewKi/mF6Av1JJn3Oc9hYD4z97oJT6D4V1l1nQm CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wg7cjj28m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:33:00 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41Q4LBMd012205;
	Mon, 26 Feb 2024 04:33:00 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wg7cjj283-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:33:00 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q3MF2R012348;
	Mon, 26 Feb 2024 04:32:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wfwg1x7md-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:32:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41Q4WtAA5112354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 04:32:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9111A2004B;
	Mon, 26 Feb 2024 04:32:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36D7C20040;
	Mon, 26 Feb 2024 04:32:54 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 Feb 2024 04:32:54 +0000 (GMT)
Date: Mon, 26 Feb 2024 10:02:51 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <ZdwUc96KRsrKrd9c@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
 <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zdg0O/67vQIip7hN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223210456.GP19790@gate.crashing.org>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223210456.GP19790@gate.crashing.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JQtSD2Oc2otRpi6uCwsGY-zvhPNMDAgt
X-Proofpoint-GUID: xw2HcTzOnMPKmz_fWg-RLV4vHxzN7ILH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_01,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=284 malwarescore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402260032

On 2024-02-23 15:04:56, Segher Boessenkool wrote:
> On Fri, Feb 23, 2024 at 11:29:23AM +0530, Kautuk Consul wrote:
> > > > difference (e.g. by running the command in a tight loop many times)?
> > Running a single loop many times will not expose much because that loop
> > (which is NOT within a Forth colon subroutine) will compile only once.
> > In my performance benchmarking with tb@ I have put 45 IF-THEN and
> > IF2-THEN2 control statements that will each compile once and reveal the
> > difference in compilation speeds.
> 
> All of this is only for things compiled in interpretation mode anyway.
> Even how you get the source code in (read it from a slow flash rom in
> the best case!) dominates performance.
> 
> You do not write things in Forth because it is perfect speed.  Write
> things directly in machine code if you want that, or in another high-
> level language that emphasises optimal execution speed.  The good things
> about Forth are rapid prototyping, immediate testing of all code you
> write, simple compact code, that kind of goodness.  Ideal for (system)
> firmware!
> 
> 
> Segher

Yes, but SLOF will be there on the product we sell to our customers.
Considering that there is a noticeable improvement in performance I just
thought maybe IBM management would be interested in it.

