Return-Path: <kvm-ppc+bounces-122-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A58168D0030
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 May 2024 14:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C87071C20C66
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 May 2024 12:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DAA15E5A2;
	Mon, 27 May 2024 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b="I9VlTTXY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mBjzT9Xu"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from wfout5-smtp.messagingengine.com (wfout5-smtp.messagingengine.com [64.147.123.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B098815DBCA
	for <kvm-ppc@vger.kernel.org>; Mon, 27 May 2024 12:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716813539; cv=none; b=eQ4ipAgibI39C4JJ8OHu97BdjOT6D7MQqAOe0iG3XNdkmgedDEnkyQW2sPtGsmHX6rkKu/EVzJmKVUS0Z+1zMcWYnyDLDZjrxHepzl1TIJ2HaTborBKhZvt+7IMSZ0yI6J4mTR7GZUYo3Rle5TVEnPTw9eqOsZqJJIkTrDnvjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716813539; c=relaxed/simple;
	bh=GrQnqcehT/PY5TVkgjCiSD6UlBDHUJFZweTWkuxJljs=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=dWy38NZgNflHAilMpvjwP3jtpOtuLt7WtkNQqNiPK2gMTAWKfHOebrM5ujDYL1uFwHaKkfxH8qGLIdczhcLw19relD9LvTFpTx6FLS31SDZN4fDfHrdCaTW9SoQZBgFFSRWsTaBzzvqbK9DkjVx5rmMNDA/S72gIOqiFOCwft0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru; spf=pass smtp.mailfrom=ozlabs.ru; dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b=I9VlTTXY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mBjzT9Xu; arc=none smtp.client-ip=64.147.123.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.ru
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailfout.west.internal (Postfix) with ESMTP id C821F1C00099;
	Mon, 27 May 2024 08:38:54 -0400 (EDT)
Received: from imap53 ([10.202.2.103])
  by compute1.internal (MEProxy); Mon, 27 May 2024 08:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.ru; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1716813534; x=1716899934; bh=l9XCtLRsQt
	c0rZ1HYakahaWjnIr7tg9GKaxk7FxopBM=; b=I9VlTTXYDniJu7mzIroiSMERkS
	MUi4fplAwed2dGlg6KxOKZfy5zdeW1eAUe0kBZclcEEDZDvAUu1JVhmEOJTW2Mro
	3/dfQ0GvLW64VjcTX065jWsIH8DSb1ag96PWY6IUdHG503zjq7noXda1YZEo08xj
	lPaVe/79jXRM5PuuVSd71hOiu1eY+joLNo6Oo8Iv/8CHcHI3uuTQmXabZA3Z9Zxr
	DzdKB09xx8AEFh6VkNlPB/dMXDhJk3Fhg9KpRw+GmDki2PFNMsW9u6+IylpZl7pF
	MUvcsPQMGhajzljnoXsROhtreY86SWpA5s6erho+qP5IGMH/pA3K7WC6fzLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1716813534; x=1716899934; bh=l9XCtLRsQtc0rZ1HYakahaWjnIr7
	tg9GKaxk7FxopBM=; b=mBjzT9XuDxvVnLjV7LgilAW9ZtBskw7z7pH2vL91wTD0
	Q7bohdaeBLji9RNyiUtK+64hVGf3uOxAeWyhI3Rl4pm+8/QFcXlEf1q47hR6ra5Q
	1MCApd1q0YaskW8lYgaUX7DB4cn/7877oRNZX5FicbpiAohQs4O1As9EQdlaKF41
	KXQrCoJ7E7Tz56pXFuaO3uVtuCcPd9S727BIingH2O0X/oVkYrIVyRX2x3rtaUSl
	IqfUPLqAWBbzbxEEXf0/c5ZJnOPqeWEuMhpkeTNdCi2NjEiZJKoOCpQ66BfdckNw
	eZP0pcZ5Gg+T33GglLRvyre3kJc0Npp7X2G5ukO7Jw==
X-ME-Sender: <xms:3n5UZoPtOMAXf8h2sJspLex50i5kApHG2Y_KgnEQTGheuEnQmExeYA>
    <xme:3n5UZu_uWtS0ZjZS2T_uo8udKWQ_l2OA9AGZrowB8I0roRazCvPC6sxjddRJ-WvGp
    nadbGD5GHJ0wtxrsws>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdejgedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehl
    vgigvgihucfmrghruggrshhhvghvshhkihihfdcuoegrihhksehoiihlrggsshdrrhhuqe
    enucggtffrrghtthgvrhhnpefggeevffffvdehgefhteetgedvieehudejfeduieeuvdeu
    vdevgfeufeefuedvvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrihhksehoiihlrggsshdrrhhu
X-ME-Proxy: <xmx:3n5UZvTNFpsIbwYienqEJ3m2M0RqOYJYA8foejpMLjNv4CmXAkW31Q>
    <xmx:3n5UZgtVkj_Fnthr3bcRK6FxzpV552KDQVYaWb1PrMY53JfLOKJnqA>
    <xmx:3n5UZgfcHbaJb_q4wV8b254SlIEen8rqpCRQW4o1Bp9YENE8TCz-QA>
    <xmx:3n5UZk2Vv8ejf34Em9KutupwY8Wph5IocwlW9pNQcmRqKNh8VNVGpQ>
    <xmx:3n5UZlGoGgzK5m1ldaRo_QCifhNuBe8iejhaAmieQ4ZjMh7WqiNUDJrs>
Feedback-ID: i6e394913:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 16671364006F; Mon, 27 May 2024 08:38:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-491-g033e30d24-fm-20240520.001-g033e30d2
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <3295674d-343c-4585-96f0-2161422287de@app.fastmail.com>
In-Reply-To: 
 <Zk2zExcW7u6BJhyT@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
 <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZjS3qfuj+iopSZjR@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZkMqEvgG0HxpdVzs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <34720d52-89ed-43b1-9811-40eb61904b55@app.fastmail.com>
 <Zk2zExcW7u6BJhyT@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Date: Mon, 27 May 2024 22:38:33 +1000
From: "Alexey Kardashevskiy" <aik@ozlabs.ru>
To: "Kautuk Consul" <kconsul@linux.ibm.com>
Cc: "Thomas Huth" <thuth@redhat.com>, slof@lists.ozlabs.org,
 kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v4] slof/fs/packages/disk-label.fs: improve checking for DOS
 boot partitions
Content-Type: text/plain



On Wed, 22 May 2024, at 18:55, Kautuk Consul wrote:
> Hi,
> 
> On 2024-05-20 19:03:25, Alexey Kardashevskiy wrote:
> > 
> > 
> > On Tue, 14 May 2024, at 19:08, Kautuk Consul wrote:
> > > Hi Alexey/Segher,
> > > > > :-). But this is the only other path that doesn't have a CATCH
> > > > > like the do-load subroutine in slof/fs/boot.fs. According to Segher
> > > > > there shouldn't ever be a problem with throw because if nothing else the
> > > > > outer-most interpreter loop's CATCH will catch the exception. But I
> > > > > thought to cover this throw in read-sector more locally in places near
> > > > > to this functionality. Because the outermost FORTH SLOF interpreter loop is not
> > > > > really so related to reading a sector in disk-label.fs.
> > > > > 
> > > > Alexey/Segher, so what should be the next steps ?
> > > > Do you find my explanation above okay or should I simply remove these
> > > > CATCH blocks ? Putting a CATCH block in count-dos-logical-partitions is
> > > > out of the question as there is already a CATCH in do-load in
> > > > slof/fs/boot.fs. This CATCH block in the open subroutine is actually to
> > > > prevent the exception to be caught at some non-local place in the code.
> > > 
> > > Any ideas on how we proceed with this now ?
> > 
> > 
> > Ufff, I dropped the ball again :-/
> > 
> > Sorry but if read-sector cannot read a sector because of misconfiguration (not because some underlying hardware error) - this tells me that this should be handled when we open the block device which we knows the size of in sectors and if it is not an integer - barf there. Or it is not possible? In general, when you tweak libvirt xml like this - there are plenty of ways to break SLOF, this one is not worth of another exception throwing imho. Thanks,
> 
> Sure, no issues. Just thought to send in this patch as we encountered
> this problem. Will abandon this email chain now. Thanks again! :-)

btw I was wondering what if you passed 513 as sector size, for example, have you tried? ;)

