Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9A34F810
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhCaEjY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:39:24 -0400
Received: from ozlabs.org ([203.11.71.1]:36269 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhCaEjC (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 00:39:02 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9D9K1Dyvz9sVq; Wed, 31 Mar 2021 15:39:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617165541; bh=KTxKn4A+3y7wOzGjUOwDKHrFATZ4opklwIOLGfFtl0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aDBKOXI5biBBBFdJoMVfTdjpmxNhcPhxiS0DWIZ0KZ5TPSxTuBCW/kNuvu7RJc5Tc
         u6EIswJbEO1dLvQgUE6/SU3CM6fQzErjJRy0aoxDQEG/ra9ZFFx66YCuoyMFHLp+Yr
         GqjXjcznadVV+1if4re722p/lva2tIQFhI3MO50KnjFdpWaNZHVU+d3xxmg38ohhnA
         kct/2xsPxCV2EURw/TQFcK/szkDRkCBxPqVUJG6/3G1URnhex3N2bMhx7hmqRIxl6R
         l/DJg50qClhVspKo/RUfAj3lTN8QA6fOERu0iSWcD7zoNGBlYCYW7yOH2D5NropORO
         xdIX6nM9KUs+w==
Date:   Wed, 31 Mar 2021 15:35:29 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 05/46] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
Message-ID: <YGP8Ee8aCt/ryhH+@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-6-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-6-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:24AM +1000, Nicholas Piggin wrote:
> This SPR is set to 0 twice when exiting the guest.
> 
> Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
