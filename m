Return-Path: <kvm-ppc+bounces-83-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC1688FD62
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 11:48:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F7461C20CDD
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 10:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DD253818;
	Thu, 28 Mar 2024 10:48:41 +0000 (UTC)
X-Original-To: kvm-ppc@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592F0651AB
	for <kvm-ppc@vger.kernel.org>; Thu, 28 Mar 2024 10:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711622921; cv=none; b=n3Hw4DQUpXnDHvC01JloPfvEr6njLiINIpFsSL9RY6MKCrUCkkLlvZV17JfgJ8ylZSfabb3/9oSnSjLWzgyROUCGtIQ1bQsbnhHPt5S7PAZ42o8hkBwThcl3W2ugtVwIKKwA5WDbI0yEqt0rQfJS3aBquh54bLzLqMNHH6RYi+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711622921; c=relaxed/simple;
	bh=8guG+aeUOGzKjIby/5/CbzhMBUQ95lt4r4mPYiMxVME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CjMi7Hni4aB9tsFeG+NvHniGUIPiK1wJu8HsF4M7JfWVqWa/i/CgTD5n9gKyDYSYFUsKeNgkGzVhyImssUMVjyJ7GylLxVdD3K7y9FHGNvdPVY0y3yxfdWVUgsyZzwP3Swk+2S6AF4db0fwAmuH1hb9us7s5v8FvgmN7EPXS0v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 42SAlRv3014795;
	Thu, 28 Mar 2024 05:47:27 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 42SAlQwI014794;
	Thu, 28 Mar 2024 05:47:26 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 28 Mar 2024 05:47:25 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Kautuk Consul <kconsul@linux.ibm.com>
Cc: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v3] slof/fs/packages/disk-label.fs: improve checking for DOS boot partitions
Message-ID: <20240328104725.GJ19790@gate.crashing.org>
References: <20240327054127.633598-1-kconsul@linux.ibm.com> <20240327134325.GF19790@gate.crashing.org> <ZgT0eCsT8SEiHV2Y@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgT0eCsT8SEiHV2Y@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
User-Agent: Mutt/1.4.2.3i

On Thu, Mar 28, 2024 at 10:09:20AM +0530, Kautuk Consul wrote:
> On 2024-03-27 08:43:25, Segher Boessenkool wrote:
> > If an exception happens you can (should!) throw an exception.  Which
> > you can then catch at a pretty high level.
> Ah, correct. Thanks for the suggestion! I think I will now try to throw
> an exception from read-sector if all the code-paths imply that a "catch"
> is in progress.

Don't try to detect something is trying to catch things.  Just throw!
Always *something* will catch things (the outer interpreter, if nothing
else), anyway.  In SLOF this is very explicit:

: quit
  BEGIN
    0 rdepth!    \ clear nesting stack
    [            \ switch to interpretation state
    terminal     \ all input and output not redirected
    BEGIN
      depth . [char] > emit space  \ output prompt
      refill WHILE
      space
      ['] interpret catch          \ that is all the default throw/catch
                                   \ there is!  no special casing needed
      dup print-status             \ "ok" or "aborted" or abort" string
    REPEAT
  AGAIN ;

The whole programming model is that you can blindly throw a fatal error
whenever one happens.  You cannot deal with it anyway, it is fatal!
That is 98% or so of the exceptions you'll ever see.  Very sometimes it
is used for non-local control flow.  That has its place, but please
don't overuse that :-)


Segher

