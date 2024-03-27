Return-Path: <kvm-ppc+bounces-77-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7D888D609
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 06:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 963A81C23017
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 05:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5B61429E;
	Wed, 27 Mar 2024 05:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dpww8+ck"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AD04A35
	for <kvm-ppc@vger.kernel.org>; Wed, 27 Mar 2024 05:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711518494; cv=none; b=CFHmtoUzt7+H8/F2FXTQe7DJsxMqOHfQzlCcDgK68/hQSebCewk9nC/Ur969rj/on6vOuXWtzWQVsOajhZynuWpqHT+VvkuwT22zZHLbm8mYBrPOAzD/T45kDwuj9lXp3UjEms7z/KS6Qq8GNfj5vBvAiFSNsyVOaCuAUsWHrss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711518494; c=relaxed/simple;
	bh=jRBnPwDX/0ukkTwZcB7KLfre2rGw1AONTsDyIXiw47E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kf1fZbFCgQxs/rO7/4FnAVvqMqC56n0a9cdeNgPnY6HuE4/Ij65sqTFLlQN8sCEDnKSx8wCFgu6wNKyTwWefWdwzJRrHTL+LmS4TKTWDc0VjJHW4j/zElZPhXGA3G5seLrai4jQh5yN1Zuvs9ZYigCQ8j3l5L8g0tKR7ITzKPwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dpww8+ck; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42R5ZfuY023299;
	Wed, 27 Mar 2024 05:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=jRBnPwDX/0ukkTwZcB7KLfre2rGw1AONTsDyIXiw47E=;
 b=Dpww8+ckEgcLCPUL+EQgq74XozgHskRYkKUy1cVzk9rd+5AigHlOzlV4B3FCBKj7e+8Q
 B4SQFVC3luqEaxO3oh7tT1pf8dePw0I/y16FwW8RR+7RVrhBHW1l/zXnm0wSC8nkaGNp
 8AOWcAXnHRV/B1iKOGJ9SiJme+O3K9BoOa9NkCZK2XE0tGOz/ttd4fBG2wAY1s4d4LXi
 PUSGKc14MO3HNyH5xsK4Y303olWDWdCxtiEPm4326NKrv0Pys5AFD2zeUx3F9NfZH2Iy
 Bd9HV3WZGAWEK0bh5nBxNP4C4g4UFSo7mzl+R6NNoOjWdwErn9lQE+DVbjE/Fjpu3yGD Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x4cy201w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 05:48:05 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42R5m4Pp011007;
	Wed, 27 Mar 2024 05:48:04 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x4cy201w4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 05:48:04 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42R30KJ5012990;
	Wed, 27 Mar 2024 05:48:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x29t0mwxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 05:48:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42R5lxV150921756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 05:48:01 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58F9320040;
	Wed, 27 Mar 2024 05:47:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59D1420043;
	Wed, 27 Mar 2024 05:47:57 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.171.20.166])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 Mar 2024 05:47:57 +0000 (GMT)
Date: Wed, 27 Mar 2024 11:17:53 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: aik@ozlabs.ru, slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v2] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <ZgOzCTTrlKNXuEas@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240318103003.484602-1-kconsul@linux.vnet.ibm.com>
 <116481b9-7268-4a62-a3ac-576ffb538e1d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <116481b9-7268-4a62-a3ac-576ffb538e1d@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o17UN8Q45hWn9VeFCAqJLj5JN2-jNC_d
X-Proofpoint-ORIG-GUID: CTQij2W8zDqr6CbRpXfV1RVoP_B8RHOv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_02,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0 mlxlogscore=859
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270037

Hi Thomas,

I just sent out the v3. Can you please review that ?

Thanks again! :-)


