Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD614F6DA8
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 Nov 2019 05:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfKKEsU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 10 Nov 2019 23:48:20 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:37503 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfKKEsU (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 10 Nov 2019 23:48:20 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47BJKZ0HnRz9sQw; Mon, 11 Nov 2019 15:48:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573447698; bh=yWa/bTKeJR+SWjF4oDpRITo/DdE/biB73QYlEC6JpL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bfNGKxOxX0YieQvmzH4cVLji1M8lzU7qkhZ0QbMeNg162OTCpojGm9v/MU5Rppcwj
         oNXh0rfODIwOiQv7bV/eQbdx0KFsfcXoedK8ikpBWsiGOvcVAZuE6o6bIuzzWBD5Zq
         lSSEs5IMFILXoZgeBGc01eOa/k4wOm6bib7wv/E9Ijz7NT2XieIpQqBuUJyQFVFV6k
         jmd4g/YGW+ahwM8QcSUo6pjy/SZCZU6vY/xr3efVJyfq5TJ1G2TeUASi6UDpCqUZUX
         6Kl86phXK/vd2XYcuTIakguIHH+NhbB6NsRSgTU4ecD0mmvm45ES0+JH4Pg6irxU+u
         hNJpMzmePAKow==
Date:   Mon, 11 Nov 2019 15:25:35 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: Re: [PATCH v10 5/8] KVM: PPC: Handle memory plug/unplug to secure VM
Message-ID: <20191111042535.GB4017@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-6-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-6-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:57AM +0530, Bharata B Rao wrote:
> Register the new memslot with UV during plug and unregister
> the memslot during unplug. In addition, release all the
> device pages during unplug.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 	[Added skip_page_out arg to kvmppc_uvmem_drop_pages()]

Reviewed-by: Paul Mackerras <paulus@ozlabs.org>
