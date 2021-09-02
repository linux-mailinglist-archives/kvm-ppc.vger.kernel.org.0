Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E9A3FEE60
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Sep 2021 15:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhIBNJY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Sep 2021 09:09:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344993AbhIBNJV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Sep 2021 09:09:21 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 182D3heT017467;
        Thu, 2 Sep 2021 09:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=eThGAUXXmw+IkLaHbn+zHjlR21pCpK6b0ul2tukVdFQ=;
 b=dFPgt341xOyElVA88qiOCzyU+5AY2F7+CcodH+C/JgjxXW/9AG6k8ivaOJe1b153Cp1g
 uoz4geM+3KmUbiZ7XuU4wpEPSYp9gR1F+iJkRaPsvLwjp0kCgc8ttarHfz0oIOhMT58c
 DX+s6C9SIxu+yKuSW7CtnIUbARifH7QpvlUFZCw1tLEepChVr6PLRvCc0EGG36W1hp0u
 perv7raDXZzR6X0QFxJYyEURZ5+HKXvypY6d/eXO9L6YQ/15+Q/L6rDYN/MQ0NN9DlXn
 RsQe1AHj/7lm9RuA/q5VBgZ19qT+aQq13UcVVynjUN24e2+GntWcGwv0o+uD2z5AUbq0 Fw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3atx7thv44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Sep 2021 09:08:12 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 182CuoGv029968;
        Thu, 2 Sep 2021 13:08:11 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3atdxbqhtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Sep 2021 13:08:11 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 182D897644499304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Sep 2021 13:08:10 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF865AE066;
        Thu,  2 Sep 2021 13:08:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7E28AE064;
        Thu,  2 Sep 2021 13:08:08 +0000 (GMT)
Received: from localhost (unknown [9.211.46.111])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Sep 2021 13:08:08 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH kernel] KVM: PPC: Book3S: Suppress warnings when
 allocating too big memory slots
In-Reply-To: <a72edcd2-a990-a549-2f31-dab134bef6a6@ozlabs.ru>
References: <20210901084512.1658628-1-aik@ozlabs.ru>
 <87fsuouysc.fsf@linux.ibm.com>
 <a72edcd2-a990-a549-2f31-dab134bef6a6@ozlabs.ru>
Date:   Thu, 02 Sep 2021 10:08:05 -0300
Message-ID: <878s0funuy.fsf@linux.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TCkyYlb5QNUlbed3M7FdwT0Ke8NBK1N7
X-Proofpoint-GUID: TCkyYlb5QNUlbed3M7FdwT0Ke8NBK1N7
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-02_04:2021-09-02,2021-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2108310000 definitions=main-2109020080
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> On 02/09/2021 00:59, Fabiano Rosas wrote:
>> Alexey Kardashevskiy <aik@ozlabs.ru> writes:
>> 
>>> The userspace can trigger "vmalloc size %lu allocation failure: exceeds
>>> total pages" via the KVM_SET_USER_MEMORY_REGION ioctl.
>>>
>>> This silences the warning by checking the limit before calling vzalloc()
>>> and returns ENOMEM if failed.
>>>
>>> This does not call underlying valloc helpers as __vmalloc_node() is only
>>> exported when CONFIG_TEST_VMALLOC_MODULE and __vmalloc_node_range() is not
>>> exported at all.
>>>
>>> Spotted by syzkaller.
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> ---
>>>   arch/powerpc/kvm/book3s_hv.c | 8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>>> index 474c0cfde384..a59f1cccbcf9 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -4830,8 +4830,12 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
>>>   	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
>>>
>>>   	if (change == KVM_MR_CREATE) {
>>> -		slot->arch.rmap = vzalloc(array_size(npages,
>>> -					  sizeof(*slot->arch.rmap)));
>>> +		unsigned long cb = array_size(npages, sizeof(*slot->arch.rmap));
>> 
>> What does cb mean?
>
> "count of bytes"
>
> This is from my deep Windows past :)
>
> https://docs.microsoft.com/en-us/windows/win32/stg/coding-style-conventions

=D How interesting! And according to that link 'sz' means "Zero terminated
String". Imagine the confusion.. haha

>> 
>>> +
>>> +		if ((cb >> PAGE_SHIFT) > totalram_pages())
>>> +			return -ENOMEM;
>>> +
>>> +		slot->arch.rmap = vzalloc(cb);
>>>   		if (!slot->arch.rmap)
>>>   			return -ENOMEM;
>>>   	}
