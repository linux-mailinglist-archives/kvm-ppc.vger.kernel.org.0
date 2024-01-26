Return-Path: <kvm-ppc+bounces-38-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CD483D624
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jan 2024 10:24:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5438CB24248
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jan 2024 09:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6E78C17;
	Fri, 26 Jan 2024 08:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=severnouse.com header.i=@severnouse.com header.b="O5euxG/U"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mail.severnouse.com (mail.severnouse.com [141.95.160.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9BD13FEE
	for <kvm-ppc@vger.kernel.org>; Fri, 26 Jan 2024 08:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.95.160.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259059; cv=none; b=IQSLGT/zik/Mh44MsS6Vs5K+ybfNwOivKLcow3jR108bVNhqEbKmQ50DZvXawhVc7eCibU40W5YnyEMmWWqrGSyJynexmDQdj56b7NdLcL51kPLSixzKy1SEocqqBW09i0iQc5pVK7NZ7AaUH+xKLc1Or9E7KmS8mXrQErJm6ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259059; c=relaxed/simple;
	bh=waaYxUsyRtmB2zEBuWcqRuRHSoYd8sJFCtgHO/3AHKE=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=j8BhCL23uh5LGKFyrV4ziqB3mcymmpx9nOEhgl4e4keFtvh2Pz8+ptu2zz4//gV4kXDU9bGZPXlLbY9xbwfQbN5X/Rq2IO3Crjng17JiQLL434Nj0UPZyl/Hjld+TQKpRQGBCgVlwwMUvqDjOwUim44aeT1fBERKB6RiBRZ0ZCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=severnouse.com; spf=pass smtp.mailfrom=severnouse.com; dkim=pass (2048-bit key) header.d=severnouse.com header.i=@severnouse.com header.b=O5euxG/U; arc=none smtp.client-ip=141.95.160.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=severnouse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=severnouse.com
Received: by mail.severnouse.com (Postfix, from userid 1002)
	id EF6A6A305B; Fri, 26 Jan 2024 08:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=severnouse.com;
	s=mail; t=1706259053;
	bh=waaYxUsyRtmB2zEBuWcqRuRHSoYd8sJFCtgHO/3AHKE=;
	h=Date:From:To:Subject:From;
	b=O5euxG/UDLdV5GgmCmvvEAgKnhal29p0SIqYGQ8ruWE2y6fX0Z2VdAPS5efp766jk
	 O0oiihdlX3bwU3Uz26vS2P3vbK6JVJ5eq3rXoZQEC+GqPktVOuOXy8SlHPcsxHw3zn
	 iQy9Mt7Cl3WQg3LA4hnazqqx2k2dE1CEqswrR361+lnDGzSQCG9K1GQWaVNdatwL2A
	 pGo9s44L6Jc6RwyvZj+fwIc8RZ5ct1ErciRdtRsc7WlAQs+A7hRsVlQ09cXsQLK9ia
	 QVnoIwCilB09X7ua8FQWbZfjppol1ujzz0UF2veM9KUokS44weVEbtN8p0WqI/5ZGB
	 YmBohnExxdjEg==
Received: by mail.severnouse.com for <kvm-ppc@vger.kernel.org>; Fri, 26 Jan 2024 08:50:38 GMT
Message-ID: <20240126074500-0.1.bo.p5k4.0.jfi4r34okn@severnouse.com>
Date: Fri, 26 Jan 2024 08:50:38 GMT
From: "Ray Galt" <ray.galt@severnouse.com>
To: <kvm-ppc@vger.kernel.org>
Subject: Meeting with the Development Team
X-Mailer: mail.severnouse.com
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I would like to reach out to the decision-maker in the IT environment wit=
hin your company.

We are a well-established digital agency in the European market. Our solu=
tions eliminate the need to build and maintain in-house IT and programmin=
g departments, hire interface designers, or employ user experience specia=
lists.

We take responsibility for IT functions while simultaneously reducing the=
 costs of maintenance. We provide support that ensures access to high-qua=
lity specialists and continuous maintenance of efficient hardware and sof=
tware infrastructure.

Companies that thrive are those that leverage market opportunities faster=
 than their competitors. Guided by this principle, we support gaining a c=
ompetitive advantage by providing comprehensive IT support.

May I present what we can do for you?


Best regards
Ray Galt

