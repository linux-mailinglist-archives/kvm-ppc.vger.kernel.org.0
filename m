Return-Path: <kvm-ppc+bounces-80-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0120288E820
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 16:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 979BF1F2B5CF
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 15:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7292F1EF0E;
	Wed, 27 Mar 2024 14:42:59 +0000 (UTC)
X-Original-To: kvm-ppc@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA97D12DDA5
	for <kvm-ppc@vger.kernel.org>; Wed, 27 Mar 2024 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711550579; cv=none; b=IEe4I3+AxTVBjIGY9WgkSYP8nn600e7Iq01UIFKRZLx/vl80PirGWEOQ8fY66mnkLepuT69ouTJiTaZ1NW9mdLrkV4yn4t0EJ0ngzKQZb6UZYUCWgXW7c41YtSsr+QvXhwI97s3fH2+iPF6I/X2r5M5Za4XDUt0VxKE2aY7LEd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711550579; c=relaxed/simple;
	bh=UeKhCUbUjAy+GdzEFT1oET5yH1fmhr4N2k8cgtNRqeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHKp5rlLvmGzs7HI69OW7xHhLtM92py0tE5bCZDZQ38Nh/JHeymuwioY/lWiq2yuxO7Xql0gLmt4IV0/POwgiHiQUu8XAmuDaO6wXH5wApcTYNz6WoAfS9Yqef/nZtzVCBejaI+hhhIHQ1jQERJMEbf3fFVg1dqHbUVpsx+HCuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 42RDhRta020529;
	Wed, 27 Mar 2024 08:43:27 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 42RDhPQJ020518;
	Wed, 27 Mar 2024 08:43:25 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Wed, 27 Mar 2024 08:43:25 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Kautuk Consul <kconsul@linux.ibm.com>
Cc: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v3] slof/fs/packages/disk-label.fs: improve checking for DOS boot partitions
Message-ID: <20240327134325.GF19790@gate.crashing.org>
References: <20240327054127.633598-1-kconsul@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327054127.633598-1-kconsul@linux.ibm.com>
User-Agent: Mutt/1.4.2.3i

Hi!

On Wed, Mar 27, 2024 at 01:41:27AM -0400, Kautuk Consul wrote:
> -\ read sector to array "block"
> -: read-sector ( sector-number -- )
> +\ read sector to array "block" and return actual bytes read
> +: read-sector-ret ( sector-number -- actual-bytes )

What does "-ret" mean?  The name could be clearer.

Why factor it like this, anyway?  Shouldn't "read" always read exactly
the number of bytes it is asked to?  So, "read-sector" should always
read exactly one sector, never more, never less.

If an exception happens you can (should!) throw an exception.  Which
you can then catch at a pretty high level.


Segher

