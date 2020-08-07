Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8076823ED43
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Aug 2020 14:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgHGMXw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 7 Aug 2020 08:23:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728245AbgHGMXv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 7 Aug 2020 08:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596803029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WCaSq3P5iLlKmhUo+4VVzO9aQrcq3PWlSM7EKazRPPY=;
        b=P+d2oMe7YYFxEPWmI+SX5Qe7+sXEa2p25BishPiTUultfNr1VL30rU29Qv4LXSDqIY4zn/
        1byVtjuGKBtizokMp/FpWY5KF5QkUGe9e47dZmBahiWqzsk+ey+cmk/fW/wboXhVRqNw/g
        grwwE18t1kYrH9EOmUmlrYx3tRvFBxo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-JRFKngmDN3yCLIVxrQkxfw-1; Fri, 07 Aug 2020 08:23:47 -0400
X-MC-Unique: JRFKngmDN3yCLIVxrQkxfw-1
Received: by mail-wm1-f70.google.com with SMTP id u68so617639wmu.3
        for <kvm-ppc@vger.kernel.org>; Fri, 07 Aug 2020 05:23:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WCaSq3P5iLlKmhUo+4VVzO9aQrcq3PWlSM7EKazRPPY=;
        b=iaZMJLUjgUXEKnhunaZ7J6dBnEojcwcljpGMEOmugSSgbkBJZM6Ixl+ATOjJByk4AK
         JBj+a5M3rN0+iODvG1so/BOhqPscYmDQmBP0zL+3GngZlqSRmFwyG3SWchsSV06fuJjB
         cqduBN4wEtXd/junsZo7J+QwwoHiFLjIZtNEcIuBGoiP2vcaaWDQ91uQJWz5ASUFLYZ6
         hlJoUtj65VZSpnrzprHGsQmPjA3jJ8BR/ALqur42lG31D24ETsHZMj5ewSs1dHI/Dzow
         hhegXQlY5zxhf6UpYcbb0y2cnWwKKeGXqu7ltfG5HHkPW0Bq7SlEKKFHL2GtmVaGtaG8
         PSmw==
X-Gm-Message-State: AOAM531nL7C+w6+rSpRiwLvUZNiLhJWR037lpUahZYpn25FrImCuowXB
        eLPfZ9sHUqOpaNRCCeXss5ghoIfms0JcxF/Kh+5g1WZndwtp0r1EkC7kZgv/ay927nzWpSie5Ij
        vdJMrmjQx8njN/TRZqQ==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr12286573wmh.23.1596803026577;
        Fri, 07 Aug 2020 05:23:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNtoYPVrH0iqO5AMwfqgSAf1OGvEjs5WjmFz4KsXTdJh4rQumUnnVViYiKUgphr0/dgPMp8g==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr12286558wmh.23.1596803026380;
        Fri, 07 Aug 2020 05:23:46 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.136.3])
        by smtp.gmail.com with ESMTPSA id c15sm9906265wme.23.2020.08.07.05.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 05:23:45 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.9-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20200728055100.GA2460422@thinks.paulus.ozlabs.org>
 <20200805000221.GA808843@thinks.paulus.ozlabs.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e0e3c1d2-c52a-1ea0-b4ef-72691a2d30c1@redhat.com>
Date:   Fri, 7 Aug 2020 14:23:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200805000221.GA808843@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 05/08/20 02:02, Paul Mackerras wrote:
> On Tue, Jul 28, 2020 at 03:51:00PM +1000, Paul Mackerras wrote:
>> Paolo,
>>
>> Please do a pull from my kvm-ppc-next-5.9-1 tag to get a PPC KVM
>> update for 5.9.  It's another relatively small update this time, the
>> main thing being a series to improve the startup time for secure VMs
>> and make memory hotplug work in secure VMs.
> Hi Paolo,
> 
> Did this get missed?

More or less; I was on vacation so I did miss it.  But I was planning
anyway to send ARM and PPC on a second pull request, I would have
noticed it when preparing it (as I did now :)).

Paolo

