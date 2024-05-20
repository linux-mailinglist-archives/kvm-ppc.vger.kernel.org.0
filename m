Return-Path: <kvm-ppc+bounces-118-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A878C9A11
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2024 11:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AAF21C20323
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2024 09:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A3517582;
	Mon, 20 May 2024 09:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b="RUJrkhL7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="j1nVUhGp"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from wfhigh6-smtp.messagingengine.com (wfhigh6-smtp.messagingengine.com [64.147.123.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A82C8BEA
	for <kvm-ppc@vger.kernel.org>; Mon, 20 May 2024 09:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716195833; cv=none; b=OYJxdg6MvVIO6yhQL8WfcTVxT+I1qRR2vN2NltP03GhpYwfsgv3Pcjw5wCaj/p6Otmov9aGLUMjyDrprQEQVuhQG/esR44wYn8Vur4wqkB0DCx2+YRpmBih3CZGZaKb+KMJ2M4hPneGDJNVwZtx2wrP94/3dSaE0EVM9+Ty3PgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716195833; c=relaxed/simple;
	bh=04fxD/f7l0PfGgfbIUSGUvmWygVDJDZ07P+ctQ7nTw8=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=C750az2pKqNkhPWmRZO17c4uML8XlsKwjTsZptfDrZopj+cgv+Xj3kSgyTq+BotmzMx55QHLnVstgqab/Z70O8EW/eCL/RnpbCAQm8YNQyF749QoUutVF96U8CRsVzP6JhFeWEzoKSIQYyO07rwodhWz9e3cVOkA0hENM/8NEt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru; spf=pass smtp.mailfrom=ozlabs.ru; dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b=RUJrkhL7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=j1nVUhGp; arc=none smtp.client-ip=64.147.123.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.ru
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailfhigh.west.internal (Postfix) with ESMTP id 903F6180010E;
	Mon, 20 May 2024 05:03:46 -0400 (EDT)
Received: from imap53 ([10.202.2.103])
  by compute1.internal (MEProxy); Mon, 20 May 2024 05:03:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.ru; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1716195826; x=1716282226; bh=C4EVksN/R7
	zYSi44F82kDCbCoFcI8eEshGkdFBJyziI=; b=RUJrkhL7lfODuRKS4Onl4TSdFh
	TwEXLRwvyStpbGqLt5uS5iAYIbQH8QkAUpBH+rDrrjRMzTo+szgzAsY4rkrFlpeq
	G47bm3mf72IhT8ceIAVlzyPfDN2GzdKDJBblXT7R7wwqJwu6GL2BMpQgsNNUEIOJ
	3MAN5jJmXQiEMrVLtcDHRki1NMdX6vav8DYe3wUZcDXWnhl9oWa4u/d5f4s5xA8r
	K5KayLDs1cw/7Bo5/wnDgYtqFDXH1rduqlk/NOP6LkfPdbXJXtJbbfAadR7uiGEd
	WeweitN0h+1Hn40ncIAM0/bxWu4KvN4+jYivHLclP5TFCbY1xum+gJzLLhuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1716195826; x=1716282226; bh=C4EVksN/R7zYSi44F82kDCbCoFcI
	8eEshGkdFBJyziI=; b=j1nVUhGpMBXn5T/uKtQSuF/rHz9KACHUSqmf7znZaz61
	++5EvcZS2af9gM6TaZmtY3CJ4o39H/HCdKv7N/A8pyLnuuVkkP+/hc/v4UCvactK
	hJcoyn7D+CTR+dxmIUX2+OGgvNJRGx4OBAsLhRtnsGh73Wo2KBB4Fg0Hd4LFdsBs
	Jc0aqoqq28SW8dJwePwbLp4UxID3rF3bxxnNaC+Xs5vKFwCSL9t4SITC32+nuBeh
	3RETdRBw8y7XpEFKRfJtGTPsJy880bUkAMJ91Ln56swAWfL4bMpJ7CY9Yeqomteh
	PS7jvpTd202ZOlBGGu56eRsL0ykCofUH+ouM60cb2Q==
X-ME-Sender: <xms:8RFLZteON5bL81wey0P_Sklx5J4U0dOaFugDlHAmwdOzhR0EURaFJw>
    <xme:8RFLZrMXJ0hfhqARdb7ACins4cehUqer-A1wAHZaL7_AqZymsLUxuveHJb0pipcxR
    ApQKl01R4yfFDAYLuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdehledgudefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    lhgvgigvhicumfgrrhgurghshhgvvhhskhhihidfuceorghikhesohiilhgrsghsrdhruh
    eqnecuggftrfgrthhtvghrnhepgfegveffffdvheeghfetteegvdeihedujeefudeiuedv
    uedvvefgueeffeeuvddvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomheprghikhesohiilhgrsghsrdhruh
X-ME-Proxy: <xmx:8RFLZmhBVOJZmnj1fMfENvDX52-Vmj7GTrwuAu6Gv9OAgF2Bgb8y6g>
    <xmx:8RFLZm-1ZtEIARcJSrpCjiavW9R9r8F0kl4I3qXemWkLEbZYPnxaYA>
    <xmx:8RFLZpu-VDBDyJZgrXy0VzFH-bTF6VsGkjrDMqyfs6bvMPZ9IC3_Ug>
    <xmx:8RFLZlEGH1lP7dUIYvOek0IheziZLkTiRnAt5VOFQCK08ov3jkGUgw>
    <xmx:8hFLZnVb8nntPzGBcy3lbOxtpTac6heaKwmLupxnxyiyd335RJKNiEtz>
Feedback-ID: i6e394913:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id ADCD43640071; Mon, 20 May 2024 05:03:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-456-gcd147058c-fm-hotfix-20240509.001-g0aad06e4
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <34720d52-89ed-43b1-9811-40eb61904b55@app.fastmail.com>
In-Reply-To: 
 <ZkMqEvgG0HxpdVzs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
 <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZjS3qfuj+iopSZjR@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZkMqEvgG0HxpdVzs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Date: Mon, 20 May 2024 19:03:25 +1000
From: "Alexey Kardashevskiy" <aik@ozlabs.ru>
To: "Kautuk Consul" <kconsul@linux.ibm.com>
Cc: "Thomas Huth" <thuth@redhat.com>, slof@lists.ozlabs.org,
 kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v4] slof/fs/packages/disk-label.fs: improve checking for DOS
 boot partitions
Content-Type: text/plain



On Tue, 14 May 2024, at 19:08, Kautuk Consul wrote:
> Hi Alexey/Segher,
> > > :-). But this is the only other path that doesn't have a CATCH
> > > like the do-load subroutine in slof/fs/boot.fs. According to Segher
> > > there shouldn't ever be a problem with throw because if nothing else the
> > > outer-most interpreter loop's CATCH will catch the exception. But I
> > > thought to cover this throw in read-sector more locally in places near
> > > to this functionality. Because the outermost FORTH SLOF interpreter loop is not
> > > really so related to reading a sector in disk-label.fs.
> > > 
> > Alexey/Segher, so what should be the next steps ?
> > Do you find my explanation above okay or should I simply remove these
> > CATCH blocks ? Putting a CATCH block in count-dos-logical-partitions is
> > out of the question as there is already a CATCH in do-load in
> > slof/fs/boot.fs. This CATCH block in the open subroutine is actually to
> > prevent the exception to be caught at some non-local place in the code.
> 
> Any ideas on how we proceed with this now ?


Ufff, I dropped the ball again :-/

Sorry but if read-sector cannot read a sector because of misconfiguration (not because some underlying hardware error) - this tells me that this should be handled when we open the block device which we knows the size of in sectors and if it is not an integer - barf there. Or it is not possible? In general, when you tweak libvirt xml like this - there are plenty of ways to break SLOF, this one is not worth of another exception throwing imho. Thanks,

