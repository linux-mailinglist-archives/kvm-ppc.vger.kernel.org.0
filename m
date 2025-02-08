Return-Path: <kvm-ppc+bounces-218-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10374A2D91E
	for <lists+kvm-ppc@lfdr.de>; Sat,  8 Feb 2025 23:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 140373A2656
	for <lists+kvm-ppc@lfdr.de>; Sat,  8 Feb 2025 22:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519B3244EBE;
	Sat,  8 Feb 2025 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b="kFn8+s8d"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from server-598995.kolorio.com (server-598995.kolorio.com [162.241.152.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AE3244EA8
	for <kvm-ppc@vger.kernel.org>; Sat,  8 Feb 2025 22:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.241.152.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739052077; cv=none; b=uDW9tJ9rFbqHch5gWbA6aZ95v51J/NiYDCMpCATUGJP8tO4GSHYIuAewcYItj31gflBQFue/qDIMuAsrCeYkkLI3KaaCvRAq/hRA6uh2ijQQsRWMi26V356YzGZUXBzqPCh49fM13hKiGqgVpZt5UXSu7jSTXi2nrMOfp0N2who=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739052077; c=relaxed/simple;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UmTztRF5V2+rSA9iQvVGFqe9hLuONRDMPKGQvecWebv8Ur/Vwr/SgVmafu8sUvICmOeehrcfnz15arZIlLPowEgAxhElVNTbXP9GHvJ5dGieBobmAuh2qThlknWxwU/GLWlsIgl6XD8Wn6v+KBbmpWaoQDnerLK/1i2MZI6v0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz; spf=pass smtp.mailfrom=truemaisha.co.tz; dkim=pass (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b=kFn8+s8d; arc=none smtp.client-ip=162.241.152.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=truemaisha.co.tz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=truemaisha.co.tz; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=; b=kFn8+s8d2cN7nB3kck8kNXQVlX
	FAhNQWvhNJg/BHEH0a8ZKNYCrgUZNHP1G8CBQr55FdIoDDra1iUDmxUTnM2mfODqT1C5dsqz1UYcA
	GCyJIjY6Vahkn6YTGt6FS5LsKsjmUHYv00R9W6m/8JHYyXH7xfyUMjv1D8Yy9RiY1oRqk/yABUDro
	VlSH7XSF7/MbSuynK0xlscw/WfR5c7UPsoBupgzHcRGHwg2x0uUe78YVYLJYOeESXjGvmAGiERfuq
	hFB2V7/qGs0Np7cFo/x958NkVwCfipgv5I9PkKcxgwkWIHHchH5YVvKiK8ttvgDdIS6rUzSNd1Rv6
	Hosi7sjA==;
Received: from [74.208.124.33] (port=59408 helo=truemaisha.co.tz)
	by server-598995.kolorio.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <chrispinerick@truemaisha.co.tz>)
	id 1tgssy-0007M7-0a
	for kvm-ppc@vger.kernel.org;
	Sat, 08 Feb 2025 16:01:13 -0600
Reply-To: dsong@aa4financialservice.com
From: David Song <chrispinerick@truemaisha.co.tz>
To: kvm-ppc@vger.kernel.org
Subject: Re: The business loan- 
Date: 08 Feb 2025 22:01:14 +0000
Message-ID: <20250208210542.1407B1693EF4BA84@truemaisha.co.tz>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server-598995.kolorio.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - truemaisha.co.tz
X-Get-Message-Sender-Via: server-598995.kolorio.com: authenticated_id: chrispinerick@truemaisha.co.tz
X-Authenticated-Sender: server-598995.kolorio.com: chrispinerick@truemaisha.co.tz
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Hello,

My name is David Song, at AA4 FS, we are a consultancy and
brokerage Firm specializing in Growth Financial Loan and joint
partnership venture. We specialize in investments in all Private
and public sectors in a broad range of areas within our Financial
Investment Services.

 We are experts in financial and operational management, due
diligence and capital planning in all markets and industries. Our
Investors wish to invest in any viable Project presented by your
Management after reviews on your Business Project Presentation
Plan.

 We look forward to your Swift response. We also offer commission
to consultants and brokers for any partnership referrals.

 Regards,
David Song
Senior Broker

AA4 Financial Services
13 Wonersh Way, Cheam,
Sutton, Surrey, SM2 7LX
Email: dsong@aa4financialservice.com


