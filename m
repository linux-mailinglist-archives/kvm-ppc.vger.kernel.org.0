Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC0625B831
	for <lists+kvm-ppc@lfdr.de>; Thu,  3 Sep 2020 03:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgICBTv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Sep 2020 21:19:51 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50015 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgICBTv (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 2 Sep 2020 21:19:51 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Bhjdx724Jz9sTS; Thu,  3 Sep 2020 11:19:49 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1599095989; bh=MQf33E+nxFrNJ3RYM11AkVoNC6j49gIxd1Ujljt7DCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cDG8uHNGSlqU99bOOrnz3GgXaVw0VfpyOfei5UzuvfEzrOCttTRdwGbqZ8aoLCNWc
         F423v7VDSXCaksm45020uc25jqQiAXXuKw/+wZpwqzgx+3XSQo+I1x8j8OxT3RcwSr
         5IesXUSH2HaCjBn+arkGbb8NZP4WT45/wA5geiAK83bHns3uj8uOTba/dUO8QFRDqv
         I0w/Q9qDkzOziKmi763aQOqy/3tPBWs452/m/kekWvFOO/ihDzmaOCpWFRiIN8/La1
         cKWe1BDuSD2XbAQ7Q8BhkDYH5AnWfXErMUDmRgpVzfhGxScLMHBbyZGlsQx0X3sjq9
         TEzBlfdXF6KRg==
Date:   Thu, 3 Sep 2020 11:19:40 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] powerpc/64s: handle ISA v3.1 local copy-paste context
 switches
Message-ID: <20200903011940.GH272502@thinks.paulus.ozlabs.org>
References: <20200825075535.224536-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825075535.224536-1-npiggin@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Aug 25, 2020 at 05:55:35PM +1000, Nicholas Piggin wrote:
> The ISA v3.1 the copy-paste facility has a new memory move functionality
> which allows the copy buffer to be pasted to domestic memory (RAM) as
> opposed to foreign memory (accelerator).
> 
> This means the POWER9 trick of avoiding the cp_abort on context switch if
> the process had not mapped foreign memory does not work on POWER10. Do the
> cp_abort unconditionally there.
> 
> KVM must also cp_abort on guest exit to prevent copy buffer state leaking
> between contexts.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

For the KVM part:

Acked-by: Paul Mackerras <paulus@ozlabs.org>
