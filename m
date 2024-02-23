Return-Path: <kvm-ppc+bounces-56-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43404861E80
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Feb 2024 22:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 625B71C23D03
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Feb 2024 21:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16030149392;
	Fri, 23 Feb 2024 21:07:20 +0000 (UTC)
X-Original-To: kvm-ppc@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3DE25750
	for <kvm-ppc@vger.kernel.org>; Fri, 23 Feb 2024 21:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708722440; cv=none; b=eQKGQzyh7k9GqlxVoZrN09ObPEXqrOQcX/K7ewWZW0w+fPQitN84bT+XeMR1CTRns63iL/EEm4n4nI654FibPTrQQi3rZjPKg24zquRD2HnJYxj/2A0ScCd59yEEfQjS/qx+PnVEUfYMcbNA96AX1LHU/RIs1mVKuIkzpTnCPXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708722440; c=relaxed/simple;
	bh=Ez1fQF58ZV9sWKdUOhROXBPgLLY0lZD6bv7PH/mHRso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltWCqSjIQPW6yaqnLT+s0o/pG0ygsL/bvscxKy1hGzuKrBMpD2d4oSLPx120sRUa7a/yQdUa13YKD1Y41YXCJQB1drYdQDeijXuaT8kO9N7arbUaAC82sTUXhcspe0jFzoNnNvdh/4zR0Nqssp4RUc9j/sq95rSIs2CDOF9o+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 41NL4vwN021619;
	Fri, 23 Feb 2024 15:04:57 -0600
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 41NL4uEX021618;
	Fri, 23 Feb 2024 15:04:56 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Fri, 23 Feb 2024 15:04:56 -0600
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Kautuk Consul <kconsul@linux.vnet.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using COMPILE
Message-ID: <20240223210456.GP19790@gate.crashing.org>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com> <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com> <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com> <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com> <Zdg0O/67vQIip7hN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zdg0O/67vQIip7hN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
User-Agent: Mutt/1.4.2.3i

On Fri, Feb 23, 2024 at 11:29:23AM +0530, Kautuk Consul wrote:
> > > difference (e.g. by running the command in a tight loop many times)?
> Running a single loop many times will not expose much because that loop
> (which is NOT within a Forth colon subroutine) will compile only once.
> In my performance benchmarking with tb@ I have put 45 IF-THEN and
> IF2-THEN2 control statements that will each compile once and reveal the
> difference in compilation speeds.

All of this is only for things compiled in interpretation mode anyway.
Even how you get the source code in (read it from a slow flash rom in
the best case!) dominates performance.

You do not write things in Forth because it is perfect speed.  Write
things directly in machine code if you want that, or in another high-
level language that emphasises optimal execution speed.  The good things
about Forth are rapid prototyping, immediate testing of all code you
write, simple compact code, that kind of goodness.  Ideal for (system)
firmware!


Segher

