Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C317E1E3709
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 May 2020 06:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgE0EVG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 May 2020 00:21:06 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50487 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728783AbgE0EVG (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 27 May 2020 00:21:06 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49WyLj5P5vz9sSw; Wed, 27 May 2020 14:21:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590553261; bh=himyVK4/uAY65Rhi/04JhPo9XxPhlLv5LE5z8MhKESQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l0pnprYuazQoMipYIrBZciz2+1zEE+BxE6jRcm0kQTRPwNwFkGTOi2YHj2M1JDBEF
         OEb1M2PDC4VLWyOFIP6PEu4BUfg0yERObU1G0M0sSRMw1Nrp8a/P9GEGClYkP9st2H
         5TfUkZe9YPBfWOBjJYI8Ii52W6rF3g+zK45nqg25Zyt2Am7BJ9jpYPsKBeU/iWS07Y
         H2OzXMTxiv+JQfLLSDODG8PhLvKqnXHIkMzaDaWAOdLZ8FTscp5aG2Sh5933tdkT42
         4Gz68BmOH4K9/68SPHTAH8FwecQRqbdFcv+53HXrTm90WqwWk60cv1gUS6QTyi6Xum
         GdX51qdSv9A/w==
Date:   Wed, 27 May 2020 14:16:05 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, linux-kernel@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>, benh@kernel.crashing.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: read ibm,secure-memory nodes
Message-ID: <20200527041605.GC293451@thinks.paulus.ozlabs.org>
References: <20200416162715.45846-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416162715.45846-1-ldufour@linux.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Apr 16, 2020 at 06:27:15PM +0200, Laurent Dufour wrote:
> The newly introduced ibm,secure-memory nodes supersede the
> ibm,uv-firmware's property secure-memory-ranges.
> 
> Firmware will no more expose the secure-memory-ranges property so first
> read the new one and if not found rollback to the older one.
> 
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>

Thanks, applied to my kvm-ppc-next branch.

Paul.
